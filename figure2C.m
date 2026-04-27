%%  LOAD BLOCK — run this instead of Block 1 and Block 2 
% Uncomment and run this block in future sessions to skip the slow loading

saveFolder = 'S:\met_narkilahti_neuro_sto-3700\MEA_data_internship\Lorenzo\OldVSNew\data';

% Load parameters + activeElec + panels + wells
load(fullfile(saveFolder, 'activeElec.mat'));
fprintf('✅ activeElec and parameters loaded.\n');

% Load active recordings DIV by DIV
recordings = struct();
for p = 1:4
    tag = panels(p).tag;
    tmp = load(fullfile(saveFolder, ['recordings_active_' tag '.mat']));
    recordings.(tag).new     = tmp.rec_active.new;
    recordings.(tag).old1    = tmp.rec_active.old1;
    recordings.(tag).old2    = tmp.rec_active.old2;
    recordings.(tag).sf_new  = tmp.rec_active.sf_new;
    recordings.(tag).sf_old1 = tmp.rec_active.sf_old1;
    recordings.(tag).sf_old2 = tmp.rec_active.sf_old2;
    fprintf('✅ %s loaded.\n', tag);
end
disp('✅ All data loaded — ready to run figures.');
%% ===================== FIGURE 2C: 8x4 RAW + LFP + SMOOTHED + SPECTROGRAM =====================
%manual choice for graph quality
repSys_old  = 'old1';
repWell_old = 'F5';
repElec_old = 'E11';

repWell_new = 'A2';
repElec_new = 'E34';


fig2C_folder = fullfile(outputFolder, 'Spectrograms', 'FIGURE2C');
if ~exist(fig2C_folder, 'dir'), mkdir(fig2C_folder); end

win_spec      = hamming(2048);
noverlap_spec = 1024;
nfft_spec     = 2048;
freq_max      = lfp_cut;
t_start       = 0;
t_end         = 150;
smooth_window = 500;
panel_order   = [4, 3, 2, 1];

repWell_new = char(repWell_new);
repElec_new = char(repElec_new);
repWell_old = char(repWell_old);
repElec_old = char(repElec_old);

results2C = struct('raw_new', {}, 'raw_old', {}, ...
                   'lfp_new', {}, 'lfp_old', {}, ...
                   'lfp_new_smooth', {}, 'lfp_old_smooth', {}, ...
                   'S_new', {}, 'S_old', {}, ...
                   'f_new_plot', {}, 'f_old_plot', {}, ...
                   'ts_new_plot', {}, 'ts_old_plot', {}, ...
                   't_new', {}, 't_old', {}, ...
                   'idx_new', {}, 'idx_old', {}, ...
                   'panel_idx', {}, 'valid', {});

S_all_new = [];
S_all_old = [];

% --- STEP 1: Pre-compute all signals and spectrograms ---
for pp = 1:4
    p   = panel_order(pp);
    tag = panels(p).tag;

    results2C(pp).panel_idx = p;
    results2C(pp).valid     = true;

    [b_new, a_new] = butter(3, lfp_cut/(recordings.(tag).sf_new/2), 'low');
    if strcmp(repSys_old, 'old1')
        sf_old  = recordings.(tag).sf_old1;
        rec_old = recordings.(tag).old1;
    else
        sf_old  = recordings.(tag).sf_old2;
        rec_old = recordings.(tag).old2;
    end
    [b_old, a_old] = butter(3, lfp_cut/(sf_old/2), 'low');

    % Check if representative electrode exists for this DIV
    if ~isfield(recordings.(tag).new, repWell_new) || ...
       ~isfield(recordings.(tag).new.(repWell_new), repElec_new)
        warning('New rep electrode not found at %s, skipping.', tag);
        results2C(pp).valid = false;
        continue
    end
    if ~isfield(rec_old, repWell_old) || ...
       ~isfield(rec_old.(repWell_old), repElec_old)
        warning('Old rep electrode not found at %s, skipping.', tag);
        results2C(pp).valid = false;
        continue
    end

    % Raw
    raw_new = recordings.(tag).new.(repWell_new).(repElec_new);
    raw_old = rec_old.(repWell_old).(repElec_old);

    % LFP filtered
    lfp_new = filtfilt(b_new, a_new, raw_new);
    lfp_old = filtfilt(b_old, a_old, raw_old);

    % LFP smoothed
    lfp_new_smooth = smoothdata(lfp_new, 'gaussian', smooth_window);
    lfp_old_smooth = smoothdata(lfp_old, 'gaussian', smooth_window);

    % Time vectors
    t_new = (0:length(raw_new)-1) / recordings.(tag).sf_new;
    t_old = (0:length(raw_old)-1) / sf_old;

    % Crop indices
    idx_new = t_new >= t_start & t_new <= t_end;
    idx_old = t_old >= t_start & t_old <= t_end;

    % Spectrograms
    [s_new, f_new, ts_new] = spectrogram(lfp_new, win_spec, noverlap_spec, nfft_spec, recordings.(tag).sf_new);
    [s_old, f_old, ts_old] = spectrogram(lfp_old, win_spec, noverlap_spec, nfft_spec, sf_old);

    idxF_new = f_new <= freq_max;
    idxF_old = f_old <= freq_max;
    idxT_new = ts_new >= t_start & ts_new <= t_end;
    idxT_old = ts_old >= t_start & ts_old <= t_end;

    S_new = 10*log10(abs(s_new(idxF_new, idxT_new)).^2);
    S_old = 10*log10(abs(s_old(idxF_old, idxT_old)).^2);

    S_all_new = [S_all_new, S_new];
    S_all_old = [S_all_old, S_old];

    results2C(pp).raw_new        = raw_new;
    results2C(pp).raw_old        = raw_old;
    results2C(pp).lfp_new        = lfp_new;
    results2C(pp).lfp_old        = lfp_old;
    results2C(pp).lfp_new_smooth = lfp_new_smooth;
    results2C(pp).lfp_old_smooth = lfp_old_smooth;
    results2C(pp).S_new          = S_new;
    results2C(pp).S_old          = S_old;
    results2C(pp).f_new_plot     = f_new(idxF_new);
    results2C(pp).f_old_plot     = f_old(idxF_old);
    results2C(pp).ts_new_plot    = ts_new(idxT_new);
    results2C(pp).ts_old_plot    = ts_old(idxT_old);
    results2C(pp).t_new          = t_new;
    results2C(pp).t_old          = t_old;
    results2C(pp).idx_new        = idx_new;
    results2C(pp).idx_old        = idx_old;

    fprintf('✅ %s pre-computed.\n', panels(p).tag);
end

clim_new_global = prctile(S_all_new(:), [2 98]);
clim_old_global = prctile(S_all_old(:), [2 98]);

% --- STEP 2: Plot ---
fig = figure('Visible','off','Position',[100 100 1800 1400]);
tl  = tiledlayout(8, 4, 'TileSpacing','compact','Padding','loose');

for pp = 1:4
    p = results2C(pp).panel_idx;

    if ~results2C(pp).valid
        for row = 0:7
            nexttile(pp + row*4);
            text(0.5, 0.5, 'No data', 'HorizontalAlignment', 'center');
            axis off;
            title([panels(p).DIV_label ' - No data']);
        end
        continue
    end

    raw_new        = results2C(pp).raw_new;
    raw_old        = results2C(pp).raw_old;
    lfp_new        = results2C(pp).lfp_new;
    lfp_old        = results2C(pp).lfp_old;
    lfp_new_smooth = results2C(pp).lfp_new_smooth;
    lfp_old_smooth = results2C(pp).lfp_old_smooth;
    S_new          = results2C(pp).S_new;
    S_old          = results2C(pp).S_old;
    f_new_plot     = results2C(pp).f_new_plot;
    f_old_plot     = results2C(pp).f_old_plot;
    ts_new_plot    = results2C(pp).ts_new_plot;
    ts_old_plot    = results2C(pp).ts_old_plot;
    t_new          = results2C(pp).t_new;
    t_old          = results2C(pp).t_old;
    idx_new        = results2C(pp).idx_new;
    idx_old        = results2C(pp).idx_old;

    % ROW 1: NEW RAW
    nexttile(pp);
    plot(t_new(idx_new), raw_new(idx_new) * 1e6, 'Color', c_new, 'LineWidth', 0.5);
    ylabel('Amplitude (µV)');
    title(['New RAW - ' panels(p).DIV_label]);
    xlim([t_start t_end]);
    grid on;

    % ROW 2: NEW LFP
    nexttile(pp + 4);
    plot(t_new(idx_new), lfp_new(idx_new) * 1e6, 'Color', c_new, 'LineWidth', 0.5);
    ylabel('Amplitude (µV)');
    title(['New LFP - ' panels(p).DIV_label]);
    xlim([t_start t_end]);
    grid on;

    % ROW 3: NEW LFP SMOOTHED
    nexttile(pp + 8);
    plot(t_new(idx_new), lfp_new_smooth(idx_new) * 1e6, 'Color', c_new, 'LineWidth', 1.5);
    ylabel('Amplitude (µV)');
    title(['New Smooth - ' panels(p).DIV_label]);
    xlim([t_start t_end]);
    grid on;

    % ROW 4: NEW SPECTROGRAM
    nexttile(pp + 12);
    imagesc(ts_new_plot, f_new_plot, S_new);
    axis xy;
    colormap(gca, 'jet');
    clim(clim_new_global);
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    title(['New Spec - ' panels(p).DIV_label]);
    colorbar;

    % ROW 5: OLD RAW
    nexttile(pp + 16);
    plot(t_old(idx_old), raw_old(idx_old) * 1e6, 'Color', c_old, 'LineWidth', 0.5);
    ylabel('Amplitude (µV)');
    title(['Old RAW - ' panels(p).DIV_label]);
    xlim([t_start t_end]);
    grid on;

    % ROW 6: OLD LFP
    nexttile(pp + 20);
    plot(t_old(idx_old), lfp_old(idx_old) * 1e6, 'Color', c_old, 'LineWidth', 0.5);
    ylabel('Amplitude (µV)');
    title(['Old LFP - ' panels(p).DIV_label]);
    xlim([t_start t_end]);
    grid on;

    % ROW 7: OLD LFP SMOOTHED
    nexttile(pp + 24);
    plot(t_old(idx_old), lfp_old_smooth(idx_old) * 1e6, 'Color', c_old, 'LineWidth', 1.5);
    ylabel('Amplitude (µV)');
    title(['Old Smooth - ' panels(p).DIV_label]);
    xlim([t_start t_end]);
    grid on;

    % ROW 8: OLD SPECTROGRAM
    nexttile(pp + 28);
    imagesc(ts_old_plot, f_old_plot, S_old);
    axis xy;
    colormap(gca, 'jet');
    clim(clim_old_global);
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    title(['Old Spec - ' panels(p).DIV_label]);
    colorbar;

end

title(tl, 'LFP signal and spectrogram: New vs Old Axion system', 'FontSize', 13);

fid = fopen(fullfile(fig2C_folder, 'representative_electrode_info.txt'), 'w');
fprintf(fid, 'NEW  → well: %s, electrode: %s\n', repWell_new, repElec_new);
fprintf(fid, 'OLD  → well: %s, electrode: %s (%s)\n', repWell_old, repElec_old, repSys_old);
fclose(fid);

exportgraphics(fig, fullfile(fig2C_folder, 'LFP_Spectrogram_NewVsOld_8x4_150s.png'), 'Resolution', 300);
savefig(fig,        fullfile(fig2C_folder, 'LFP_Spectrogram_NewVsOld_8x4_150s.fig'));
close(fig);
disp('✅ Figure 2C 8x4 saved.');