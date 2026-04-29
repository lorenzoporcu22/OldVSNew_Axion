<<<<<<< HEAD
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

=======
%% Script to generate LFPs figures
addpath(genpath('S:\met_narkilahti_neuro_sto-3700\MEA_data_internship\MEA Analysis Introduction\MEA Analysis Introduction\AxionFileInput'));
%% ===================== USER PARAMETERS =====================

% Wells are fixed across all DIVs
wells_new  = {'A1','A2','A3','A4','A5','A6','A7','A8', ...
              'B1','B2','B3','B4','B5','B6','B7','B8', ...
              'C1','C2','C3','C4','C5','C6','C7','C8'};

wells_old1 = {'F1','F2','F3','F4','F5','F6','F7','F8'};

wells_old2 = {'C1','C2','C3','C4','C5','C6','C7','C8', ...
              'D1','D2','D3','D4','D5','D6','D7','D8'};

cellLine  = 'TUBA';
duration  = 600;
threshold = 0.1;

% One panel per DIV
panels(1).DIV_label    = 'DIV 60';
panels(1).tag          = 'DIV60';
panels(1).rawFile_new  = 'S:\met_narkilahti_mea_until2025_sto-3678\Sudipta Swarna\2nd Round_045WTs and GreenTUBA\DOM27 161225\108-4504\161225_045WTs & greenTUBA_DOM27(000).raw';
panels(1).rawFile_old1 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Dravet+OGD_Ropa+Venla_N2894_N2895\DIV60\DIV60\N2894_Dravet.OGD_81-6002_DD1C.N34.N27.TUBA_D60(000).raw';
panels(1).rawFile_old2 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Cortical differentiation DravetExp6_TUBA_DD5A_DD3A_N2905\N2905_Corticaldifferentiation_TUBAN40_DD5AN39_DD3AN38_DIV60(000).raw';
panels(1).csvFile_new  = 'S:\met_narkilahti_mea_until2025_sto-3678\Sudipta Swarna\2nd Round_045WTs and GreenTUBA\DOM27 161225\108-4504\161225_045WTs & greenTUBA_DOM27(000)_spike_list.csv';
panels(1).csvFile_old1 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Dravet+OGD_Ropa+Venla_N2894_N2895\DIV60\DIV60\N2894_Dravet.OGD_81-6002_DD1C.N34.N27.TUBA_D60(000)_spike_list.csv';
panels(1).csvFile_old2 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Cortical differentiation DravetExp6_TUBA_DD5A_DD3A_N2905\DIV 60\N2905_Corticaldifferentiation_TUBAN40_DD5AN39_DD3AN38_DIV60(000)_spike_list.csv';

panels(2).DIV_label    = 'DIV 55';
panels(2).tag          = 'DIV55';
panels(2).rawFile_new  = 'S:\met_narkilahti_mea_until2025_sto-3678\Sudipta Swarna\2nd Round_045WTs and GreenTUBA\DOM22 111225\108-4504\111225_045WTs & greenTUBA_DOM22(000).raw';
panels(2).rawFile_old1 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Dravet+OGD_Ropa+Venla_N2894_N2895\DIV55\N2894_Dravet.OGD_81-6002_DD1C.N34.N27.N30_D55(000).raw';
panels(2).rawFile_old2 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Cortical differentiation DravetExp6_TUBA_DD5A_DD3A_N2905\N2905_Corticaldifferentiation_TUBAN40_DD5AN39_DD3AN38_DIV55(000).raw';
panels(2).csvFile_new  = 'S:\met_narkilahti_mea_until2025_sto-3678\Sudipta Swarna\2nd Round_045WTs and GreenTUBA\DOM22 111225\108-4504\111225_045WTs & greenTUBA_DOM22(000)_spike_list.csv';
panels(2).csvFile_old1 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Dravet+OGD_Ropa+Venla_N2894_N2895\DIV55\N2894_Dravet.OGD_81-6002_DD1C.N34.N27.N30_D55(000)_spike_list.csv';
panels(2).csvFile_old2 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Cortical differentiation DravetExp6_TUBA_DD5A_DD3A_N2905\DIV 55\N2905_Corticaldifferentiation_TUBAN40_DD5AN39_DD3AN38_DIV55(000)_spike_list.csv';

panels(3).DIV_label    = 'DIV 53';
panels(3).tag          = 'DIV53';
panels(3).rawFile_new  = 'S:\met_narkilahti_mea_until2025_sto-3678\Sudipta Swarna\2nd Round_045WTs and GreenTUBA\DOM20 091225\108-4504\091225_045WTs & greenTUBA_DOM20(000).raw';
panels(3).rawFile_old1 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Dravet+OGD_Ropa+Venla_N2894_N2895\DIV53\N2894_Dravet.OGD_81-6002_DD1C.N34.N27.N30_D53(000).raw';
panels(3).rawFile_old2 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Cortical differentiation DravetExp6_TUBA_DD5A_DD3A_N2905\N2905_Corticaldifferentiation_TUBAN40_DD5AN39_DD3AN38_DIV53(000).raw';
panels(3).csvFile_new  = 'S:\met_narkilahti_mea_until2025_sto-3678\Sudipta Swarna\2nd Round_045WTs and GreenTUBA\DOM20 091225\108-4504\091225_045WTs & greenTUBA_DOM20(000)_spike_list.csv';
panels(3).csvFile_old1 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Dravet+OGD_Ropa+Venla_N2894_N2895\DIV53\N2894_Dravet.OGD_81-6002_DD1C.N34.N27.N30_D53(000)_spike_list.csv';
panels(3).csvFile_old2 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Cortical differentiation DravetExp6_TUBA_DD5A_DD3A_N2905\DIV 53\N2905_Corticaldifferentiation_TUBAN40_DD5AN39_DD3AN38_DIV53(000)_spike_list.csv';

panels(4).DIV_label    = 'DIV 48';
panels(4).tag          = 'DIV48';
panels(4).rawFile_new  = 'S:\met_narkilahti_mea_until2025_sto-3678\Sudipta Swarna\2nd Round_045WTs and GreenTUBA\DOM15 041225\108-4504\041225_045WTs & greenTUBA_DOM15(000).raw';
panels(4).rawFile_old1 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Dravet+OGD_Ropa+Venla_N2894_N2895\DIV49\N2894_Dravet.OGD_81-6002_DD1C.N34.N27.N30.ControlBaseline_D49(000).raw';
panels(4).rawFile_old2 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Cortical differentiation DravetExp6_TUBA_DD5A_DD3A_N2905\N2905_Corticaldifferentiation_TUBAN40_DD5AN39_DD3AN38_DIV48(000).raw';
panels(4).csvFile_new  = 'S:\met_narkilahti_mea_until2025_sto-3678\Sudipta Swarna\2nd Round_045WTs and GreenTUBA\DOM15 041225\108-4504\041225_045WTs & greenTUBA_DOM15(000)_spike_list.csv';
panels(4).csvFile_old1 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Dravet+OGD_Ropa+Venla_N2894_N2895\DIV49\N2894_Dravet.OGD_81-6002_DD1C.N34.N27.N30.ControlBaseline_D49(000)_spike_list.csv';
panels(4).csvFile_old2 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Cortical differentiation DravetExp6_TUBA_DD5A_DD3A_N2905\DIV 48\N2905_Corticaldifferentiation_TUBAN40_DD5AN39_DD3AN38_DIV48(000)_spike_list.csv';


%% ===================== FIXED PARAMETERS =====================

lfp_cut      = 250;
window_psd   = hamming(4096);
noverlap_psd = 2048;
nfft_psd     = 8192;
min_active_electrodes = 3;  
c_new = [0.85 0.15 0.15];
c_old = [0.15 0.35 0.85];

outputFolder = 'S:\met_narkilahti_neuro_sto-3700\MEA_data_internship\Lorenzo\OldVSNew';
if ~exist(outputFolder, 'dir'), mkdir(outputFolder); end

%%  LOAD BLOCK — run this instead of Block 1 and Block 2 
% Uncomment and run this block in future sessions to skip the slow loading

saveFolder = 'S:\met_narkilahti_neuro_sto-3700\MEA_data_internship\Lorenzo\OldVSNew\data';

% Load parameters + activeElec + panels + wells
load(fullfile(saveFolder, 'activeElec.mat'));
fprintf('✅ activeElec and parameters loaded.\n');

% Load active recordings DIV by DIV
>>>>>>> 01467b9ca69604ec0ca29669b8258acbc334b0cf
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
<<<<<<< HEAD
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
=======
disp('✅ All data loaded — ready to run figures.');



%% ===================== EXPLORE: RAW TRACES — tutti i candidati, new + old1 + old2 =====================
% Per ogni sistema: trova elettrodi attivi in tutti e 4 i DIV, plotta raw
% Righe = elettrodi candidati, Colonne = 4 DIV (DIV48 → DIV60)

raw_explore_folder = 'S:\met_narkilahti_neuro_sto-3700\MEA_data_internship\Lorenzo\OldVSNew\Spectrograms\FIGURE2C\raw traces';
if ~exist(raw_explore_folder, 'dir'), mkdir(raw_explore_folder); end

t_explore_start = 0;
t_explore_end   = 60;   % secondi — riduci ancora se vuoi più veloce
panel_order_explore = [4, 3, 2, 1];  % DIV48 → DIV60

systems = {'new', 'old1', 'old2'};
wells_per_sys = {wells_new, wells_old1, wells_old2};
colors_per_sys = {c_new, c_old, c_old};

for s = 1:3
    sys       = systems{s};
    wells_sys = wells_per_sys{s};
    col       = colors_per_sys{s};

    % --- Trova candidati attivi in tutti e 4 i DIV ---
    candidates_sys = struct('well', {}, 'elec', {});

    for w = 1:length(wells_sys)
        wName = wells_sys{w};

        commonElec = [];
        valid = true;
        for p = 1:4
            tag  = panels(p).tag;
            ae   = activeElec.(tag).(sys);
            wIdx = find(strcmp(cellstr([ae.well]), wName));
            if isempty(wIdx), valid = false; break; end
            elecs = ae(wIdx).activeElectrodes;
            if isempty(commonElec)
                commonElec = elecs;
            else
                commonElec = intersect(commonElec, elecs);
            end
            if isempty(commonElec), valid = false; break; end
        end

        if ~valid || isempty(commonElec), continue; end

        for e = 1:length(commonElec)
            candidates_sys(end+1).well = wName;
            candidates_sys(end).elec   = char(commonElec{e});
        end
    end

    fprintf('\n=== %s: %d candidati ===\n', sys, length(candidates_sys));
    for c = 1:length(candidates_sys)
        fprintf('  %d) %s / %s\n', c, candidates_sys(c).well, candidates_sys(c).elec);
    end

    if isempty(candidates_sys)
        fprintf('  ⚠️ Nessun candidato per %s — skip.\n', sys);
        continue
    end

    nCand = length(candidates_sys);

    fig = figure('Visible', 'off', 'Position', [50 50 1800 max(400, nCand * 160)]);
    tl  = tiledlayout(nCand, 4, 'TileSpacing', 'compact', 'Padding', 'loose');
    title(tl, sprintf('RAW — %s — elettrodi attivi in tutti i DIV (%d–%d s)', ...
        sys, t_explore_start, t_explore_end), 'FontSize', 12);

    for c = 1:nCand
        wName = candidates_sys(c).well;
        eName = candidates_sys(c).elec;

        for pp = 1:4
            p   = panel_order_explore(pp);
            tag = panels(p).tag;

            nexttile((c-1)*4 + pp);

            % Selezione recording e sf corretti
            switch sys
                case 'new'
                    rec_exp = recordings.(tag).new;
                    sf_exp  = recordings.(tag).sf_new;
                case 'old1'
                    rec_exp = recordings.(tag).old1;
                    sf_exp  = recordings.(tag).sf_old1;
                case 'old2'
                    rec_exp = recordings.(tag).old2;
                    sf_exp  = recordings.(tag).sf_old2;
            end

            if ~isfield(rec_exp, wName) || ~isfield(rec_exp.(wName), eName)
                text(0.5, 0.5, 'no data', 'HorizontalAlignment', 'center');
                axis off;
            else
                raw = rec_exp.(wName).(eName);
                t   = (0:length(raw)-1) / sf_exp;
                idx = t >= t_explore_start & t <= t_explore_end;
                plot(t(idx), raw(idx) * 1e6, 'Color', col, 'LineWidth', 0.4);
                xlim([t_explore_start t_explore_end]);
                grid on;
            end

            if c == 1,  title(panels(p).DIV_label); end
            if pp == 1, ylabel(sprintf('%s / %s', wName, eName), 'FontSize', 7); end
        end
    end

    fname = sprintf('raw_candidates_%s_%d-%ds.png', sys, t_explore_start, t_explore_end);
    exportgraphics(fig, fullfile(raw_explore_folder, fname), 'Resolution', 150);
    close(fig);
    fprintf('✅ %s salvato.\n', sys);
end

disp('✅ Tutte le figure raw esplorate salvate.');
>>>>>>> 01467b9ca69604ec0ca29669b8258acbc334b0cf
