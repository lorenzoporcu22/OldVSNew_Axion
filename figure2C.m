
%% ===================== FIGURE 2C v3: 2x4 DIV60 only (horizontal) =====================
clear all
clc
addpath(genpath('S:\met_narkilahti_neuro_sto-3700\MEA_data_internship\MEA Analysis Introduction\MEA Analysis Introduction\AxionFileInput'));

%% ===================== USER PARAMETERS =====================

repWell_new = 'B7';
repElec_new = 'E22';
repWell_old = 'C1';
repElec_old = 'E34';
repSys_old  = 'old2';

div_panel = 1;  % panels(1) = DIV60

outputFolder  = 'S:\met_narkilahti_neuro_sto-3700\MEA_data_internship\Lorenzo\OldVSNew';
fig2C3_folder = fullfile(outputFolder, 'Spectrograms', 'FIGURE2C_v3');
if ~exist(fig2C3_folder, 'dir'), mkdir(fig2C3_folder); end

%% ===================== FIXED PARAMETERS =====================

lfp_cut       = 250;
freq_max      = lfp_cut;
win_spec      = hamming(2048);
noverlap_spec = 1024;
nfft_spec     = 2048;
t_start       = 0;
t_end         = 60;
smooth_window = 500;

% --- Colors ---
c_new_raw    = [0.85 0.15 0.15];
c_new_lfp    = [0.92 0.45 0.45];
c_new_smooth = [0.97 0.70 0.70];
c_old_raw    = [0.10 0.25 0.75];
c_old_lfp    = [0.35 0.55 0.90];
c_old_smooth = [0.65 0.78 0.97];

%% ===================== PANELS DEFINITION =====================

wells_new  = {'A1','A2','A3','A4','A5','A6','A7','A8', ...
              'B1','B2','B3','B4','B5','B6','B7','B8', ...
              'C1','C2','C3','C4','C5','C6','C7','C8'};
wells_old1 = {'F1','F2','F3','F4','F5','F6','F7','F8'};
wells_old2 = {'C1','C2','C3','C4','C5','C6','C7','C8', ...
              'D1','D2','D3','D4','D5','D6','D7','D8'};

cellLine  = 'TUBA';
duration  = 600;
threshold = 0.1;

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

p   = div_panel;
tag = panels(p).tag;

[b_new, a_new] = butter(3, lfp_cut/(recordings.(tag).sf_new/2), 'low');
if strcmp(repSys_old, 'old1')
    sf_old  = recordings.(tag).sf_old1;
    rec_old = recordings.(tag).old1;
else
    sf_old  = recordings.(tag).sf_old2;
    rec_old = recordings.(tag).old2;
end
[b_old, a_old] = butter(3, lfp_cut/(sf_old/2), 'low');

raw_new = recordings.(tag).new.(repWell_new).(repElec_new);
raw_old = rec_old.(repWell_old).(repElec_old);

lfp_new = filtfilt(b_new, a_new, raw_new);
lfp_old = filtfilt(b_old, a_old, raw_old);

lfp_new_smooth = smoothdata(lfp_new, 'gaussian', smooth_window);
lfp_old_smooth = smoothdata(lfp_old, 'gaussian', smooth_window);

t_new = (0:length(raw_new)-1) / recordings.(tag).sf_new;
t_old = (0:length(raw_old)-1) / sf_old;

idx_new = t_new >= t_start & t_new <= t_end;
idx_old = t_old >= t_start & t_old <= t_end;

% --- Shared Y limits (robust) ---
raw_all    = [raw_new(idx_new); raw_old(idx_old)] * 1e6;
raw_ylim   = safeYLim(raw_all(isfinite(raw_all)));

lfp_all    = [lfp_new(idx_new); lfp_old(idx_old)] * 1e6;
lfp_ylim   = safeYLim(lfp_all(isfinite(lfp_all)));

smo_all    = [lfp_new_smooth(idx_new); lfp_old_smooth(idx_old)] * 1e6;
smooth_ylim = safeYLim(smo_all(isfinite(smo_all)));

% --- Spectrograms ---
[s_new, f_new, ts_new] = spectrogram(lfp_new, win_spec, noverlap_spec, nfft_spec, recordings.(tag).sf_new);
[s_old, f_old, ts_old] = spectrogram(lfp_old, win_spec, noverlap_spec, nfft_spec, sf_old);

idxF_new = f_new <= freq_max;
idxF_old = f_old <= freq_max;
idxT_new = ts_new >= t_start & ts_new <= t_end;
idxT_old = ts_old >= t_start & ts_old <= t_end;

S_new = 10*log10(abs(s_new(idxF_new, idxT_new)).^2);
S_old = 10*log10(abs(s_old(idxF_old, idxT_old)).^2);

clim_new = prctile(S_new(:), [5 95]);
clim_old = prctile(S_old(:), [5 95]);

fprintf('✅ %s pre-computed.\n', tag);

%% ===================== PLOT 2x4 =====================

fig = figure('Visible','off','Position',[100 100 1800 500]);
tl  = tiledlayout(2, 4, 'TileSpacing','compact','Padding','loose');

% ROW 1: NEW
nexttile(1);
plot(t_new(idx_new), raw_new(idx_new) * 1e6, 'Color', c_new_raw, 'LineWidth', 0.5);
ylabel('Amplitude (µV)'); title(['New RAW - ' panels(p).DIV_label]);
xlim([t_start t_end]); ylim(raw_ylim); grid on;

nexttile(2);
plot(t_new(idx_new), lfp_new(idx_new) * 1e6, 'Color', c_new_lfp, 'LineWidth', 0.5);
ylabel('Amplitude (µV)'); title(['New LFP - ' panels(p).DIV_label]);
xlim([t_start t_end]); ylim(lfp_ylim); grid on;

nexttile(3);
plot(t_new(idx_new), lfp_new_smooth(idx_new) * 1e6, 'Color', c_new_smooth, 'LineWidth', 1.5);
ylabel('Amplitude (µV)'); title(['New Smooth - ' panels(p).DIV_label]);
xlim([t_start t_end]); ylim(smooth_ylim); grid on;

nexttile(4);
imagesc(ts_new(idxT_new), f_new(idxF_new), S_new);
axis xy; colormap(gca, 'jet'); clim(clim_new);
xlabel('Time (s)'); ylabel('Frequency (Hz)');
title(['New Spec - ' panels(p).DIV_label]); colorbar;

% ROW 2: OLD
nexttile(5);
plot(t_old(idx_old), raw_old(idx_old) * 1e6, 'Color', c_old_raw, 'LineWidth', 0.5);
ylabel('Amplitude (µV)'); title(['Old RAW - ' panels(p).DIV_label]);
xlim([t_start t_end]); ylim(raw_ylim); grid on;

nexttile(6);
plot(t_old(idx_old), lfp_old(idx_old) * 1e6, 'Color', c_old_lfp, 'LineWidth', 0.5);
ylabel('Amplitude (µV)'); title(['Old LFP - ' panels(p).DIV_label]);
xlim([t_start t_end]); ylim(lfp_ylim); grid on;

nexttile(7);
plot(t_old(idx_old), lfp_old_smooth(idx_old) * 1e6, 'Color', c_old_smooth, 'LineWidth', 1.5);
ylabel('Amplitude (µV)'); title(['Old Smooth - ' panels(p).DIV_label]);
xlim([t_start t_end]); ylim(smooth_ylim); grid on;

nexttile(8);
imagesc(ts_old(idxT_old), f_old(idxF_old), S_old);
axis xy; colormap(gca, 'jet'); clim(clim_old);
xlabel('Time (s)'); ylabel('Frequency (Hz)');
title(['Old Spec - ' panels(p).DIV_label]); colorbar;

title(tl, 'LFP signal and spectrogram: New vs Old Axion system', 'FontSize', 13);

fid = fopen(fullfile(fig2C3_folder, 'representative_electrode_info.txt'), 'w');
fprintf(fid, 'NEW  → well: %s, electrode: %s\n', repWell_new, repElec_new);
fprintf(fid, 'OLD  → well: %s, electrode: %s (%s)\n', repWell_old, repElec_old, repSys_old);
fclose(fid);

exportgraphics(fig, fullfile(fig2C3_folder, 'LFP_Spectrogram_NewVsOld_2x4_DIV60.png'), 'Resolution', 300);
savefig(fig,        fullfile(fig2C3_folder, 'LFP_Spectrogram_NewVsOld_2x4_DIV60.fig'));
close(fig);
disp('✅ Figure 2C v3 2x4 saved.');

%% ===================== HELPER FUNCTION =====================

function yl = safeYLim(v)
    if isempty(v)
        yl = [-1 1];
        return;
    end
    vmin = min(v);
    vmax = max(v);
    pad  = max((vmax - vmin) * 0.1, 1);
    yl   = [vmin - pad, vmax + pad];
    if yl(1) >= yl(2)
        yl = [yl(1) - 1, yl(1) + 1];
    end
end