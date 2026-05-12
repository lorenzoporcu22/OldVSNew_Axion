%% ===================== FIGURE COMBINED: 2C + 2A =====================
clear all
clc
addpath(genpath('S:\met_narkilahti_neuro_sto-3700\MEA_data_internship\MEA Analysis Introduction\MEA Analysis Introduction\AxionFileInput'));

%% ===================== USER PARAMETERS =====================

repWell_new = 'B7';
repElec_new = 'E22';
repWell_old = 'C1';
repElec_old = 'E34';
repSys_old  = 'old2';
div_panel   = 1;  % panels(1) = DIV60

outputFolder   = 'S:\met_narkilahti_neuro_sto-3700\MEA_data_internship\Lorenzo\OldVSNew';
figComb_folder = fullfile(outputFolder, 'FIGURE_COMBINED');
if ~exist(figComb_folder, 'dir'), mkdir(figComb_folder); end

%% ===================== FIXED PARAMETERS =====================

% --- Signal / spectrogram ---
lfp_cut       = 250;
freq_max      = lfp_cut;
smooth_window = 500;
win_spec      = hamming(2048);
noverlap_spec = 1024;
nfft_spec     = 2048;
t_start       = 0;
t_end         = 60;

% --- PSD (2A) ---
window_psd            = hann(25000);   % 2s @ 12500 Hz
noverlap_psd          = 12500;
nfft_psd              = 32768;
lfp_cut_psd           = 200;
min_active_electrodes = 3;
panel_order_2A        = [4, 3, 2, 1]; % DIV ascending: 48, 53, 55, 60

% --- Colors ---
c_new        = [0.85 0.15 0.15];
c_old        = [0.15 0.35 0.85];
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

panels(1).DIV_label = 'DIV 60'; panels(1).tag = 'DIV60';
panels(1).rawFile_new  = 'S:\met_narkilahti_mea_until2025_sto-3678\Sudipta Swarna\2nd Round_045WTs and GreenTUBA\DOM27 161225\108-4504\161225_045WTs & greenTUBA_DOM27(000).raw';
panels(1).rawFile_old1 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Dravet+OGD_Ropa+Venla_N2894_N2895\DIV60\DIV60\N2894_Dravet.OGD_81-6002_DD1C.N34.N27.TUBA_D60(000).raw';
panels(1).rawFile_old2 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Cortical differentiation DravetExp6_TUBA_DD5A_DD3A_N2905\N2905_Corticaldifferentiation_TUBAN40_DD5AN39_DD3AN38_DIV60(000).raw';
panels(1).csvFile_new  = 'S:\met_narkilahti_mea_until2025_sto-3678\Sudipta Swarna\2nd Round_045WTs and GreenTUBA\DOM27 161225\108-4504\161225_045WTs & greenTUBA_DOM27(000)_spike_list.csv';
panels(1).csvFile_old1 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Dravet+OGD_Ropa+Venla_N2894_N2895\DIV60\DIV60\N2894_Dravet.OGD_81-6002_DD1C.N34.N27.TUBA_D60(000)_spike_list.csv';
panels(1).csvFile_old2 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Cortical differentiation DravetExp6_TUBA_DD5A_DD3A_N2905\DIV 60\N2905_Corticaldifferentiation_TUBAN40_DD5AN39_DD3AN38_DIV60(000)_spike_list.csv';

panels(2).DIV_label = 'DIV 55'; panels(2).tag = 'DIV55';
panels(2).rawFile_new  = 'S:\met_narkilahti_mea_until2025_sto-3678\Sudipta Swarna\2nd Round_045WTs and GreenTUBA\DOM22 111225\108-4504\111225_045WTs & greenTUBA_DOM22(000).raw';
panels(2).rawFile_old1 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Dravet+OGD_Ropa+Venla_N2894_N2895\DIV55\N2894_Dravet.OGD_81-6002_DD1C.N34.N27.N30_D55(000).raw';
panels(2).rawFile_old2 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Cortical differentiation DravetExp6_TUBA_DD5A_DD3A_N2905\N2905_Corticaldifferentiation_TUBAN40_DD5AN39_DD3AN38_DIV55(000).raw';
panels(2).csvFile_new  = 'S:\met_narkilahti_mea_until2025_sto-3678\Sudipta Swarna\2nd Round_045WTs and GreenTUBA\DOM22 111225\108-4504\111225_045WTs & greenTUBA_DOM22(000)_spike_list.csv';
panels(2).csvFile_old1 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Dravet+OGD_Ropa+Venla_N2894_N2895\DIV55\N2894_Dravet.OGD_81-6002_DD1C.N34.N27.N30_D55(000)_spike_list.csv';
panels(2).csvFile_old2 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Cortical differentiation DravetExp6_TUBA_DD5A_DD3A_N2905\DIV 55\N2905_Corticaldifferentiation_TUBAN40_DD5AN39_DD3AN38_DIV55(000)_spike_list.csv';

panels(3).DIV_label = 'DIV 53'; panels(3).tag = 'DIV53';
panels(3).rawFile_new  = 'S:\met_narkilahti_mea_until2025_sto-3678\Sudipta Swarna\2nd Round_045WTs and GreenTUBA\DOM20 091225\108-4504\091225_045WTs & greenTUBA_DOM20(000).raw';
panels(3).rawFile_old1 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Dravet+OGD_Ropa+Venla_N2894_N2895\DIV53\N2894_Dravet.OGD_81-6002_DD1C.N34.N27.N30_D53(000).raw';
panels(3).rawFile_old2 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Cortical differentiation DravetExp6_TUBA_DD5A_DD3A_N2905\N2905_Corticaldifferentiation_TUBAN40_DD5AN39_DD3AN38_DIV53(000).raw';
panels(3).csvFile_new  = 'S:\met_narkilahti_mea_until2025_sto-3678\Sudipta Swarna\2nd Round_045WTs and GreenTUBA\DOM20 091225\108-4504\091225_045WTs & greenTUBA_DOM20(000)_spike_list.csv';
panels(3).csvFile_old1 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Dravet+OGD_Ropa+Venla_N2894_N2895\DIV53\N2894_Dravet.OGD_81-6002_DD1C.N34.N27.N30_D53(000)_spike_list.csv';
panels(3).csvFile_old2 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Cortical differentiation DravetExp6_TUBA_DD5A_DD3A_N2905\DIV 53\N2905_Corticaldifferentiation_TUBAN40_DD5AN39_DD3AN38_DIV53(000)_spike_list.csv';

panels(4).DIV_label = 'DIV 48'; panels(4).tag = 'DIV48';
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

%% ===================== PRE-COMPUTE 2C =====================

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

raw_ylim    = safeYLim([raw_new(idx_new); raw_old(idx_old)] * 1e6);
lfp_ylim    = safeYLim([lfp_new(idx_new); lfp_old(idx_old)] * 1e6);
smooth_ylim = safeYLim([lfp_new_smooth(idx_new); lfp_old_smooth(idx_old)] * 1e6);

[s_new, f_new, ts_new] = spectrogram(lfp_new, win_spec, noverlap_spec, nfft_spec, recordings.(tag).sf_new);
[s_old, f_old, ts_old] = spectrogram(lfp_old, win_spec, noverlap_spec, nfft_spec, sf_old);

idxF_new = f_new <= freq_max;  idxF_old = f_old <= freq_max;
idxT_new = ts_new >= t_start & ts_new <= t_end;
idxT_old = ts_old >= t_start & ts_old <= t_end;

S_new = 10*log10(abs(s_new(idxF_new, idxT_new)).^2);
S_old = 10*log10(abs(s_old(idxF_old, idxT_old)).^2);

clim_new = prctile(S_new(:), [5 95]);
clim_old = prctile(S_old(:), [5 95]);

fprintf('✅ 2C pre-computed.\n');

%% ===================== PRE-COMPUTE 2A =====================

results2A    = struct();
y_min_global =  Inf;
y_max_global = -Inf;

for pp = 1:4
    p   = panel_order_2A(pp);
    tag = panels(p).tag;

    [b_n,  a_n]  = butter(3, lfp_cut_psd/(recordings.(tag).sf_new/2),  'low');
    [b_o1, a_o1] = butter(3, lfp_cut_psd/(recordings.(tag).sf_old1/2), 'low');
    [b_o2, a_o2] = butter(3, lfp_cut_psd/(recordings.(tag).sf_old2/2), 'low');

    wPSD_new  = computeWellPSD(recordings.(tag).new,  wells_new,  activeElec.(tag).new,  b_n,  a_n,  recordings.(tag).sf_new,  window_psd, noverlap_psd, nfft_psd, lfp_cut_psd, min_active_electrodes);
    wPSD_old1 = computeWellPSD(recordings.(tag).old1, wells_old1, activeElec.(tag).old1, b_o1, a_o1, recordings.(tag).sf_old1, window_psd, noverlap_psd, nfft_psd, lfp_cut_psd, min_active_electrodes);
    wPSD_old2 = computeWellPSD(recordings.(tag).old2, wells_old2, activeElec.(tag).old2, b_o2, a_o2, recordings.(tag).sf_old2, window_psd, noverlap_psd, nfft_psd, lfp_cut_psd, min_active_electrodes);
    wPSD_old  = [wPSD_old1, wPSD_old2];

    [~, f_tmp] = pwelch(zeros(nfft_psd,1), window_psd, noverlap_psd, nfft_psd, recordings.(tag).sf_new);

    results2A(pp).wellPSD_new = wPSD_new;
    results2A(pp).wellPSD_old = wPSD_old;
    results2A(pp).f_plot      = f_tmp(f_tmp <= lfp_cut_psd);
    results2A(pp).panel_idx   = p;
    results2A(pp).n_new       = size(wPSD_new, 2);
    results2A(pp).n_old       = size(wPSD_old, 2);

    % Global Y limits
    mean_n = mean(wPSD_new, 2);  n_n = size(wPSD_new, 2);
    mean_o = mean(wPSD_old, 2);  n_o = size(wPSD_old, 2);
    ci_u_n = mean_n + 1.96 * std(wPSD_new, 0, 2) / sqrt(n_n);
    ci_l_n = mean_n - 1.96 * std(wPSD_new, 0, 2) / sqrt(n_n);
    ci_u_o = mean_o + 1.96 * std(wPSD_old, 0, 2) / sqrt(n_o);
    ci_l_o = mean_o - 1.96 * std(wPSD_old, 0, 2) / sqrt(n_o);

    y_min_global = min(y_min_global, min([10*log10(ci_l_n); 10*log10(ci_l_o)]));
    y_max_global = max(y_max_global, max([10*log10(ci_u_n); 10*log10(ci_u_o)]));

    fprintf('✅ 2A %s: n_new=%d, n_old=%d\n', panels(p).tag, size(wPSD_new,2), size(wPSD_old,2));
end

y_min_global = floor(y_min_global - 2);
y_max_global = -110;  % forced per consistenza con figura standalone

fprintf('✅ 2A pre-computed. Y limits: [%.1f, %.1f] dB/Hz\n', y_min_global, y_max_global);

%% ===================== COMBINED FIGURE =====================

fig = figure('Visible','off','Position',[100 100 1800 950]);

% Layout verticale:
%   top (A): 2C — due righe di segnali, ~65% altezza
%   bottom (B): 2A — una riga di PSD, ~28% altezza

col_w   = 0.200;
col_gap = 0.035;
left    = 0.055;
col_x   = left + (0:3) * (col_w + col_gap);

% Row positions (normalized, bottom-up)
row_new_y  = 0.66;   % NEW signal row
row_old_y  = 0.40;   % OLD signal row
row_psd_y  = 0.05;   % PSD row
row_sig_h  = 0.22;   % height signal rows
row_psd_h  = 0.24;   % height PSD row

% Panel label (A) — abbassato di poco per stare dentro l'immagine
annotation('textbox', [0.005 0.95 0.03 0.03], 'String', '\bf(A)', ...
    'FontSize', 14, 'EdgeColor', 'none', 'VerticalAlignment', 'top');

%% --- Column titles (only on NEW row) ---
col_titles = {'Broadband signal', 'LFP (0–250 Hz)', 'LFP envelope', 'Spectrogram'};
for c = 1:4
    annotation('textbox', [col_x(c) row_new_y+row_sig_h+0.005 col_w 0.03], ...
        'String', col_titles{c}, 'FontSize', 10, 'FontWeight', 'bold', ...
        'EdgeColor', 'none', 'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom');
end

%% --- ROW 1: NEW ---

% Col 1 — Broadband, row label "New system"
ax = subplot('Position', [col_x(1) row_new_y col_w row_sig_h]);
plot(t_new(idx_new), raw_new(idx_new)*1e6, 'Color', c_new_raw, 'LineWidth', 0.5);
ylabel({'New system'; 'Amplitude (µV)'}, 'FontWeight', 'bold');
xlim([t_start t_end]); ylim(raw_ylim); grid on;
set(ax, 'XTickLabel', []);

% Col 2 — LFP
ax = subplot('Position', [col_x(2) row_new_y col_w row_sig_h]);
plot(t_new(idx_new), lfp_new(idx_new)*1e6, 'Color', c_new_lfp, 'LineWidth', 0.5);
ylabel('Amplitude (µV)');
xlim([t_start t_end]); ylim(lfp_ylim); grid on;
set(ax, 'XTickLabel', []);

% Col 3 — Envelope
ax = subplot('Position', [col_x(3) row_new_y col_w row_sig_h]);
plot(t_new(idx_new), lfp_new_smooth(idx_new)*1e6, 'Color', c_new_smooth, 'LineWidth', 1.5);
ylabel('Amplitude (µV)');
xlim([t_start t_end]); ylim(smooth_ylim); grid on;
set(ax, 'XTickLabel', []);

% Col 4 — Spectrogram
ax = subplot('Position', [col_x(4) row_new_y col_w row_sig_h]);
imagesc(ts_new(idxT_new), f_new(idxF_new), S_new);
axis xy; colormap(ax, 'jet'); clim(clim_new);
ylabel('Frequency (Hz)'); colorbar;
set(ax, 'XTickLabel', []);

%% --- ROW 2: OLD ---

% Col 1 — Broadband, row label "Old system"
ax = subplot('Position', [col_x(1) row_old_y col_w row_sig_h]);
plot(t_old(idx_old), raw_old(idx_old)*1e6, 'Color', c_old_raw, 'LineWidth', 0.5);
ylabel({'Old system'; 'Amplitude (µV)'}, 'FontWeight', 'bold');
xlim([t_start t_end]); ylim(raw_ylim); grid on;
xlabel('Time (s)');

% Col 2 — LFP
ax = subplot('Position', [col_x(2) row_old_y col_w row_sig_h]);
plot(t_old(idx_old), lfp_old(idx_old)*1e6, 'Color', c_old_lfp, 'LineWidth', 0.5);
ylabel('Amplitude (µV)');
xlim([t_start t_end]); ylim(lfp_ylim); grid on;
xlabel('Time (s)');

% Col 3 — Envelope
ax = subplot('Position', [col_x(3) row_old_y col_w row_sig_h]);
plot(t_old(idx_old), lfp_old_smooth(idx_old)*1e6, 'Color', c_old_smooth, 'LineWidth', 1.5);
ylabel('Amplitude (µV)');
xlim([t_start t_end]); ylim(smooth_ylim); grid on;
xlabel('Time (s)');

% Col 4 — Spectrogram
ax = subplot('Position', [col_x(4) row_old_y col_w row_sig_h]);
imagesc(ts_old(idxT_old), f_old(idxF_old), S_old);
axis xy; colormap(ax, 'jet'); clim(clim_old);
ylabel('Frequency (Hz)'); xlabel('Time (s)'); colorbar;

%% --- Panel label (B) ---
annotation('textbox', [0.005 0.32 0.03 0.03], 'String', '\bf(B)', ...
    'FontSize', 14, 'EdgeColor', 'none', 'VerticalAlignment', 'top');

%% --- ROW 3: 2A PSD ---

for pp = 1:4
    p   = results2A(pp).panel_idx;
    wn  = results2A(pp).wellPSD_new;
    wo  = results2A(pp).wellPSD_old;
    fp  = results2A(pp).f_plot;
    n_n = results2A(pp).n_new;
    n_o = results2A(pp).n_old;

    mn  = mean(wn, 2);  ci_un = mn + 1.96*std(wn,0,2)/sqrt(n_n);  ci_ln = mn - 1.96*std(wn,0,2)/sqrt(n_n);
    mo  = mean(wo, 2);  ci_uo = mo + 1.96*std(wo,0,2)/sqrt(n_o);  ci_lo = mo - 1.96*std(wo,0,2)/sqrt(n_o);

    ax = subplot('Position', [col_x(pp) row_psd_y col_w row_psd_h]);
    hold on;

    fill([fp; flipud(fp)], [10*log10(ci_un); flipud(10*log10(ci_ln))], ...
         c_new, 'FaceAlpha', 0.15, 'EdgeColor', 'none', 'HandleVisibility', 'off');
    plot(fp, 10*log10(mn), 'Color', c_new, 'LineWidth', 2, ...
         'DisplayName', sprintf('New (n=%d)', n_n));

    fill([fp; flipud(fp)], [10*log10(ci_uo); flipud(10*log10(ci_lo))], ...
         c_old, 'FaceAlpha', 0.15, 'EdgeColor', 'none', 'HandleVisibility', 'off');
    plot(fp, 10*log10(mo), 'Color', c_old, 'LineWidth', 2, ...
         'DisplayName', sprintf('Old (n=%d)', n_o));

    title(panels(p).DIV_label);
    xlabel('Frequency (Hz)');
    ylim([y_min_global y_max_global]);
    grid on; legend('Location', 'northeast'); hold off;

    if pp == 1
        ylabel('Power (dB/Hz)');
    else
        set(ax, 'YTickLabel', []);
    end
end

%% ===================== EXPORT =====================

exportgraphics(fig, fullfile(figComb_folder, 'Figure_Combined_2C_2A.png'), 'Resolution', 300);
savefig(fig,        fullfile(figComb_folder, 'Figure_Combined_2C_2A.fig'));
close(fig);

fid = fopen(fullfile(figComb_folder, 'representative_electrode_info.txt'), 'w');
fprintf(fid, 'NEW  → well: %s, electrode: %s\n', repWell_new, repElec_new);
fprintf(fid, 'OLD  → well: %s, electrode: %s (%s)\n', repWell_old, repElec_old, repSys_old);
fclose(fid);

disp('✅ Combined figure saved.');

%% ===================== HELPER FUNCTIONS =====================

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

function yl = safeYLim(v)
    v = v(isfinite(v));
    if isempty(v), yl = [-1 1]; return; end
    vmin = min(v);  vmax = max(v);
    pad  = max((vmax - vmin) * 0.1, 1);
    yl   = [vmin - pad, vmax + pad];
    if yl(1) >= yl(2), yl = [yl(1)-1, yl(1)+1]; end
end