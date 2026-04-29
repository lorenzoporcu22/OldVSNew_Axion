%% ===================== FIGURE 2C v2: 8x2 LFP + SPECTROGRAM (DIV 55 and DIV 60) =====================
clear all
clc
addpath(genpath('S:\met_narkilahti_neuro_sto-3700\MEA_data_internship\MEA Analysis Introduction\MEA Analysis Introduction\AxionFileInput'));

%% ===================== USER PARAMETERS =====================

% --- Representative electrodes (manual selection) ---
repWell_new = 'A2';
repElec_new = 'E32';
repWell_old = 'C3';
repElec_old = 'E34';
repSys_old  = 'old2';

% --- DIVs to display ---
div_panels = [2, 1];  % panels(2)=DIV55, panels(1)=DIV60 → ascending left to right

% --- Output folder ---
outputFolder = 'S:\met_narkilahti_neuro_sto-3700\MEA_data_internship\Lorenzo\OldVSNew';
fig2C2_folder = fullfile(outputFolder, 'Spectrograms', 'FIGURE2C_v2');
if ~exist(fig2C2_folder, 'dir'), mkdir(fig2C2_folder); end

%% ===================== FIXED PARAMETERS =====================

lfp_cut       = 250;
freq_max      = lfp_cut;
c_new         = [0.85 0.15 0.15];
c_old         = [0.15 0.35 0.85];
win_spec      = hamming(2048);
noverlap_spec = 1024;
nfft_sec     = 2048;
t_start       = 0;
t_end         = 60;
smooth_window = 500;

%% ===================== LOAD BLOCK =====================

saveFolder = 'S:\met_narkilahti_neuro_sto-3700\MEA_data_internship\Lorenzo\OldVSNew\data';

load(fullfile(saveFolder, 'activeElec.mat'));
fprintf('✅ activeElec and parameters loaded.\n');

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
disp('✅ All data loaded.');

%% ===================== PRE-COMPUTE =====================

results2C2 = struct('raw_new', {}, 'raw_old', {}, ...
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

for pp = 1:length(div_panels)
    p   = div_panels(pp);
    tag = panels(p).tag;

    results2C2(pp).panel_idx = p;
    results2C2(pp).valid     = true;

    [b_new, a_new] = butter(3, lfp_cut/(recordings.(tag).sf_new/2), 'low');
    if strcmp(repSys_old, 'old1')
        sf_old  = recordings.(tag).sf_old1;
        rec_old = recordings.(tag).old1;
    else
        sf_old  = recordings.(tag).sf_old2;
        rec_old = recordings.(tag).old2;
    end
    [b_old, a_old] = butter(3, lfp_cut/(sf_old/2), 'low');

    % Check existence
    if ~isfield(recordings.(tag).new, repWell_new) || ...
       ~isfield(recordings.(tag).new.(repWell_new), repElec_new)
        warning('New rep electrode not found at %s, skipping.', tag);
        results2C2(pp).valid = false;
        continue
    end
    if ~isfield(rec_old, repWell_old) || ...
       ~isfield(rec_old.(repWell_old), repElec_old)
        warning('Old rep electrode not found at %s, skipping.', tag);
        results2C2(pp).valid = false;
        continue
    end

    % Raw
    raw_new = recordings.(tag).new.(repWell_new).(repElec_new);
    raw_old = rec_old.(repWell_old).(repElec_old);

    % LFP
    lfp_new = filtfilt(b_new, a_new, raw_new);
    lfp_old = filtfilt(b_old, a_old, raw_old);

    % Smoothed
    lfp_new_smooth = smoothdata(lfp_new, 'gaussian', smooth_window);
    lfp_old_smooth = smoothdata(lfp_old, 'gaussian', smooth_window);

    % Time vectors
    t_new = (0:length(raw_new)-1) / recordings.(tag).sf_new;
    t_old = (0:length(raw_old)-1) / sf_old;

    % Crop
    idx_new = t_new >= t_start & t_new <= t_end;
    idx_old = t_old >= t_start & t_old <= t_end;

    % Spectrograms
    [s_new, f_new, ts_new] = spectrogram(lfp_new, win_spec, noverlap_spec, nfft_sec, recordings.(tag).sf_new);
    [s_old, f_old, ts_old] = spectrogram(lfp_old, win_spec, noverlap_spec, nfft_sec, sf_old);

    idxF_new = f_new <= freq_max;
    idxF_old = f_old <= freq_max;
    idxT_new = ts_new >= t_start & ts_new <= t_end;
    idxT_old = ts_old >= t_start & ts_old <= t_end;

    S_new = 10*log10(abs(s_new(idxF_new, idxT_new)).^2);
    S_old = 10*log10(abs(s_old(idxF_old, idxT_old)).^2);

    S_all_new = [S_all_new, S_new];
    S_all_old = [S_all_old, S_old];

    results2C2(pp).raw_new        = raw_new;
    results2C2(pp).raw_old        = raw_old;
    results2C2(pp).lfp_new        = lfp_new;
    results2C2(pp).lfp_old        = lfp_old;
    results2C2(pp).lfp_new_smooth = lfp_new_smooth;
    results2C2(pp).lfp_old_smooth = lfp_old_smooth;
    results2C2(pp).S_new          = S_new;
    results2C2(pp).S_old          = S_old;
    results2C2(pp).f_new_plot     = f_new(idxF_new);
    results2C2(pp).f_old_plot     = f_old(idxF_old);
    results2C2(pp).ts_new_plot    = ts_new(idxT_new);
    results2C2(pp).ts_old_plot    = ts_old(idxT_old);
    results2C2(pp).t_new          = t_new;
    results2C2(pp).t_old          = t_old;
    results2C2(pp).idx_new        = idx_new;
    results2C2(pp).idx_old        = idx_old;

    fprintf('✅ %s pre-computed.\n', tag);
end

clim_new_global = prctile(S_all_new(:), [2 98]);
clim_old_global = prctile(S_all_old(:), [2 98]);

%% ===================== PLOT =====================

fig = figure('Visible','off','Position',[100 100 900 1400]);
tl  = tiledlayout(8, 2, 'TileSpacing','compact','Padding','loose');

for pp = 1:length(div_panels)
    p = results2C2(pp).panel_idx;

    if ~results2C2(pp).valid
        for row = 0:7
            nexttile(pp + row*2);
            text(0.5, 0.5, 'No data', 'HorizontalAlignment', 'center');
            axis off;
            title([panels(p).DIV_label ' - No data']);
        end
        continue
    end

    raw_new        = results2C2(pp).raw_new;
    raw_old        = results2C2(pp).raw_old;
    lfp_new        = results2C2(pp).lfp_new;
    lfp_old        = results2C2(pp).lfp_old;
    lfp_new_smooth = results2C2(pp).lfp_new_smooth;
    lfp_old_smooth = results2C2(pp).lfp_old_smooth;
    S_new          = results2C2(pp).S_new;
    S_old          = results2C2(pp).S_old;
    f_new_plot     = results2C2(pp).f_new_plot;
    f_old_plot     = results2C2(pp).f_old_plot;
    ts_new_plot    = results2C2(pp).ts_new_plot;
    ts_old_plot    = results2C2(pp).ts_old_plot;
    t_new          = results2C2(pp).t_new;
    t_old          = results2C2(pp).t_old;
    idx_new        = results2C2(pp).idx_new;
    idx_old        = results2C2(pp).idx_old;

    % ROW 1: NEW RAW
    nexttile(pp);
    plot(t_new(idx_new), raw_new(idx_new) * 1e6, 'Color', c_new, 'LineWidth', 0.5);
    ylabel('Amplitude (µV)');
    title(['New RAW - ' panels(p).DIV_label]);
    xlim([t_start t_end]);
    grid on;

    % ROW 2: NEW LFP
    nexttile(pp + 2);
    plot(t_new(idx_new), lfp_new(idx_new) * 1e6, 'Color', c_new, 'LineWidth', 0.5);
    ylabel('Amplitude (µV)');
    title(['New LFP - ' panels(p).DIV_label]);
    xlim([t_start t_end]);
    grid on;

    % ROW 3: NEW SMOOTH
    nexttile(pp + 4);
    plot(t_new(idx_new), lfp_new_smooth(idx_new) * 1e6, 'Color', c_new, 'LineWidth', 1.5);
    ylabel('Amplitude (µV)');
    title(['New Smooth - ' panels(p).DIV_label]);
    xlim([t_start t_end]);
    grid on;

    % ROW 4: NEW SPECTROGRAM
    nexttile(pp + 6);
    imagesc(ts_new_plot, f_new_plot, S_new);
    axis xy;
    colormap(gca, 'jet');
    clim(clim_new_global);
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    title(['New Spec - ' panels(p).DIV_label]);
    colorbar;

    % ROW 5: OLD RAW
    nexttile(pp + 8);
    plot(t_old(idx_old), raw_old(idx_old) * 1e6, 'Color', c_old, 'LineWidth', 0.5);
    ylabel('Amplitude (µV)');
    title(['Old RAW - ' panels(p).DIV_label]);
    xlim([t_start t_end]);
    grid on;

    % ROW 6: OLD LFP
    nexttile(pp + 10);
    plot(t_old(idx_old), lfp_old(idx_old) * 1e6, 'Color', c_old, 'LineWidth', 0.5);
    ylabel('Amplitude (µV)');
    title(['Old LFP - ' panels(p).DIV_label]);
    xlim([t_start t_end]);
    grid on;

    % ROW 7: OLD SMOOTH
    nexttile(pp + 12);
    plot(t_old(idx_old), lfp_old_smooth(idx_old) * 1e6, 'Color', c_old, 'LineWidth', 1.5);
    ylabel('Amplitude (µV)');
    title(['Old Smooth - ' panels(p).DIV_label]);
    xlim([t_start t_end]);
    grid on;

    % ROW 8: OLD SPECTROGRAM
    nexttile(pp + 14);
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

fid = fopen(fullfile(fig2C2_folder, 'representative_electrode_info.txt'), 'w');
fprintf(fid, 'NEW  → well: %s, electrode: %s\n', repWell_new, repElec_new);
fprintf(fid, 'OLD  → well: %s, electrode: %s (%s)\n', repWell_old, repElec_old, repSys_old);
fclose(fid);

exportgraphics(fig, fullfile(fig2C2_folder, 'LFP_Spectrogram_NewVsOld_8x2.png'), 'Resolution', 300);
savefig(fig,        fullfile(fig2C2_folder, 'LFP_Spectrogram_NewVsOld_8x2.fig'));
close(fig);
disp('✅ Figure 2C v2 8x2 saved.');

%% ===================== HELPER FUNCTION =====================

function wellPSD = computeWellPSD(rec, wells, activeElecPerWell, b, a, sf, window_psd, noverlap_psd, nfft_psd, lfp_cut, min_active)
    wellPSD = [];
    for w = 1:length(wells)
        wName = wells{w};
        if ~isfield(rec, wName), continue; end
        wellIdx = find(strcmp(cellstr([activeElecPerWell.well]), wName));
        if isempty(wellIdx), continue; end
        activeNames = activeElecPerWell(wellIdx).activeElectrodes;
        if length(activeNames) < min_active, continue; end
        elecPSD = [];
        for e = 1:length(activeNames)
            eName = activeNames{e};
            if ~isfield(rec.(wName), eName), continue; end
            data     = filtfilt(b, a, rec.(wName).(eName));
            [pxx, f] = pwelch(data, window_psd, noverlap_psd, nfft_psd, sf);
            idxF     = f <= lfp_cut;
            if isempty(elecPSD)
                elecPSD = zeros(sum(idxF), length(activeNames));
            end
            elecPSD(:, e) = pxx(idxF);
        end
        if isempty(elecPSD), continue; end
        wellPSD(:, end+1) = mean(elecPSD, 2);
    end
end


%% ===================== RAW SIGNAL PLOT: All active electrodes Old system =====================

% --- User parameters ---
system_to_plot = 'old2';   % 'old1' or 'old2'
div_panels     = [2, 1];   % DIV55 and DIV60

t_start = 0;
t_end   = 60;

saveFolder_raw = 'S:\met_narkilahti_neuro_sto-3700\MEA_data_internship\Lorenzo\OldVSNew\Spectrograms\FIGURE2C_v2\old systems raw';
if ~exist(saveFolder_raw, 'dir'), mkdir(saveFolder_raw); end

for pp = 1:length(div_panels)
    p   = div_panels(pp);
    tag = panels(p).tag;

    if strcmp(system_to_plot, 'old1')
        rec_old      = recordings.(tag).old1;
        sf_old       = recordings.(tag).sf_old1;
        activeElec_old = activeElec.(tag).old1;
        wells_old    = wells_old1;
    else
        rec_old      = recordings.(tag).old2;
        sf_old       = recordings.(tag).sf_old2;
        activeElec_old = activeElec.(tag).old2;
        wells_old    = wells_old2;
    end

    % Collect all active electrodes across all wells
    allElec = {};
    for w = 1:length(wells_old)
        wName   = wells_old{w};
        wellIdx = find(strcmp(cellstr([activeElec_old.well]), wName));
        if isempty(wellIdx), continue; end
        activeNames = activeElec_old(wellIdx).activeElectrodes;
        if isempty(activeNames), continue; end
        for e = 1:length(activeNames)
            eName = char(activeNames{e});
            if ~isfield(rec_old, wName), continue; end
            if ~isfield(rec_old.(wName), eName), continue; end
            allElec{end+1} = struct('well', wName, 'elec', eName);
        end
    end

    nElec = length(allElec);
    fprintf('%s %s: %d active electrodes found.\n', system_to_plot, tag, nElec);

    % --- Plot ---
    nCols = 4;
    nRows = ceil(nElec / nCols);

    fig = figure('Visible','off','Position',[100 100 1800 nRows*150]);
    tl  = tiledlayout(nRows, nCols, 'TileSpacing','compact','Padding','loose');

    for i = 1:nElec
        wName = allElec{i}.well;
        eName = allElec{i}.elec;

        raw = rec_old.(wName).(eName);
        t   = (0:length(raw)-1) / sf_old;

        idx = t >= t_start & t <= t_end;

        nexttile;
        plot(t(idx), raw(idx) * 1e6, 'Color', c_old, 'LineWidth', 0.5);
        title([wName ' - ' eName]);
        xlabel('Time (s)');
        ylabel('µV');
        xlim([t_start t_end]);
        grid on;
    end

    title(tl, sprintf('RAW signals — %s %s (%d active electrodes)', ...
        system_to_plot, panels(p).DIV_label, nElec), 'FontSize', 12);

    saveName = sprintf('RAW_%s_%s.png', system_to_plot, tag);
    exportgraphics(fig, fullfile(saveFolder_raw, saveName), 'Resolution', 300);
    savefig(fig, fullfile(saveFolder_raw, strrep(saveName, '.png', '.fig')));
    close(fig);

    fprintf('✅ %s %s saved.\n', system_to_plot, tag);
end

disp('✅ All raw plots saved.');