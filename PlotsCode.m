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

%% BLOCK 1: LOAD RAW RECORDINGS 
% % Run this block once — it is slow
% 
% recordings = struct();
% 
% for p = 1:4
%     tag = panels(p).tag;
%     fprintf('Loading panel %d of 4 (%s)...\n', p, tag);
% 
%     [recordings.(tag).new,  recordings.(tag).sf_new,  ~, ~, ~] = loadAxionRecordings_auto(panels(p).rawFile_new,  wells_new,  cellLine, 0);
%     [recordings.(tag).old1, recordings.(tag).sf_old1, ~, ~, ~] = loadAxionRecordings_auto(panels(p).rawFile_old1, wells_old1, cellLine, 0);
%     [recordings.(tag).old2, recordings.(tag).sf_old2, ~, ~, ~] = loadAxionRecordings_auto(panels(p).rawFile_old2, wells_old2, cellLine, 0);
% 
%     fprintf('✅ %s raw data loaded.\n', tag);
% end
% disp('✅ All raw recordings loaded.');
% 
% %% BLOCK 2: DETECT ACTIVE ELECTRODES
% % Fast — run after Block 1
% 
% activeElec = struct();
% 
% for p = 1:4
%     tag = panels(p).tag;
% 
%     activeElec.(tag).new  = detectActiveElectrodes(panels(p).csvFile_new,  duration, threshold);
%     activeElec.(tag).old1 = detectActiveElectrodes(panels(p).csvFile_old1, duration, threshold);
%     activeElec.(tag).old2 = detectActiveElectrodes(panels(p).csvFile_old2, duration, threshold);
% 
%     fprintf('✅ %s active electrodes detected.\n', tag);
% end
% disp('✅ All active electrodes detected.');
% 
% 
% %% SAVING BLOCK
% 
% % Run once after Block 1 and Block 2
% % Saves only active electrodes per DIV per system — much smaller than full recordings
% 
% saveFolder = fullfile(outputFolder, 'data');
% if ~exist(saveFolder, 'dir'), mkdir(saveFolder); end
% 
% for p = 1:4
%     tag = panels(p).tag;
%     fprintf('Saving %s...\n', tag);
% 
%     % --- Extract only active electrodes from recordings ---
%     rec_active = struct();
%     rec_active.sf_new  = recordings.(tag).sf_new;
%     rec_active.sf_old1 = recordings.(tag).sf_old1;
%     rec_active.sf_old2 = recordings.(tag).sf_old2;
% 
%     % NEW
%     for w = 1:length(wells_new)
%         wName = wells_new{w};
%         wellIdx = find(strcmp(cellstr([activeElec.(tag).new.well]), wName));
%         if isempty(wellIdx), continue; end
%         activeNames = activeElec.(tag).new(wellIdx).activeElectrodes;
%         if isempty(activeNames), continue; end
%         for e = 1:length(activeNames)
%             eName = activeNames{e};
%             if ~isfield(recordings.(tag).new, wName), continue; end
%             if ~isfield(recordings.(tag).new.(wName), eName), continue; end
%             rec_active.new.(wName).(eName) = recordings.(tag).new.(wName).(eName);
%         end
%     end
% 
%     % OLD1
%     for w = 1:length(wells_old1)
%         wName = wells_old1{w};
%         wellIdx = find(strcmp(cellstr([activeElec.(tag).old1.well]), wName));
%         if isempty(wellIdx), continue; end
%         activeNames = activeElec.(tag).old1(wellIdx).activeElectrodes;
%         if isempty(activeNames), continue; end
%         for e = 1:length(activeNames)
%             eName = activeNames{e};
%             if ~isfield(recordings.(tag).old1, wName), continue; end
%             if ~isfield(recordings.(tag).old1.(wName), eName), continue; end
%             rec_active.old1.(wName).(eName) = recordings.(tag).old1.(wName).(eName);
%         end
%     end
% 
%     % OLD2
%     for w = 1:length(wells_old2)
%         wName = wells_old2{w};
%         wellIdx = find(strcmp(cellstr([activeElec.(tag).old2.well]), wName));
%         if isempty(wellIdx), continue; end
%         activeNames = activeElec.(tag).old2(wellIdx).activeElectrodes;
%         if isempty(activeNames), continue; end
%         for e = 1:length(activeNames)
%             eName = activeNames{e};
%             if ~isfield(recordings.(tag).old2, wName), continue; end
%             if ~isfield(recordings.(tag).old2.(wName), eName), continue; end
%             rec_active.old2.(wName).(eName) = recordings.(tag).old2.(wName).(eName);
%         end
%     end
% 
%     % --- Save to disk ---
%     saveFile = fullfile(saveFolder, ['recordings_active_' tag '.mat']);
%     save(saveFile, 'rec_active', '-v7.3');
%     fprintf('✅ %s saved → %s\n', tag, saveFile);
% 
% end
% disp('✅ All active recordings saved.');
% 
% saveFile_ae = fullfile(saveFolder, 'activeElec.mat');
% save(saveFile_ae, 'activeElec', 'panels', 'wells_new', 'wells_old1', 'wells_old2', ...
%      'lfp_cut', 'window_psd', 'noverlap_psd', 'nfft_psd', 'c_new', 'c_old', ...
%      'outputFolder', 'duration', 'threshold', 'cellLine');
% fprintf('✅ activeElec + parameters saved → %s\n', saveFile_ae);

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

%% ===================== FIGURE 2A: LFP PSD overlay 1x4 =====================
% 
% Averaging:
% Level 1: PSD averaged across active electrodes → well-level PSD
% Level 2: well-level PSDs averaged across valid wells → system-level PSD
% 
% Statistics:
% 95% CI: mean ± 1.96 × (SD / √n_wells)
% Old system: Old1 and Old2 pooled together (n_wells = n_old1 + n_old2)



fig2A_folder = fullfile(outputFolder, 'LFP_PSD', 'FIGURE2A');
if ~exist(fig2A_folder, 'dir'), mkdir(fig2A_folder); end

panel_order           = [4, 3, 2, 1];  % DIV ascending: 48, 53, 55, 60
min_active_electrodes = 3;
y_min_global          =  Inf;
y_max_global          = -Inf;

% --- STEP 1: Pre-compute PSDs and store results ---
results = struct();

for pp = 1:4
    p   = panel_order(pp);
    tag = panels(p).tag;

    [b_new,  a_new]  = butter(3, lfp_cut/(recordings.(tag).sf_new/2),  'low');
    [b_old1, a_old1] = butter(3, lfp_cut/(recordings.(tag).sf_old1/2), 'low');
    [b_old2, a_old2] = butter(3, lfp_cut/(recordings.(tag).sf_old2/2), 'low');

    wellPSD_new  = computeWellPSD(recordings.(tag).new,  wells_new,  activeElec.(tag).new,  b_new,  a_new,  recordings.(tag).sf_new,  window_psd, noverlap_psd, nfft_psd, lfp_cut, min_active_electrodes);
    wellPSD_old1 = computeWellPSD(recordings.(tag).old1, wells_old1, activeElec.(tag).old1, b_old1, a_old1, recordings.(tag).sf_old1, window_psd, noverlap_psd, nfft_psd, lfp_cut, min_active_electrodes);
    wellPSD_old2 = computeWellPSD(recordings.(tag).old2, wells_old2, activeElec.(tag).old2, b_old2, a_old2, recordings.(tag).sf_old2, window_psd, noverlap_psd, nfft_psd, lfp_cut, min_active_electrodes);

    [~, f] = pwelch(zeros(nfft_psd,1), window_psd, noverlap_psd, nfft_psd, recordings.(tag).sf_new);

    results(pp).wellPSD_new = wellPSD_new;
    results(pp).wellPSD_old = [wellPSD_old1, wellPSD_old2];
    results(pp).f_plot      = f(f <= lfp_cut);
    results(pp).panel_idx   = p;

    % Update global Y limits
    mean_new  = mean(wellPSD_new, 2);
    n_new     = size(wellPSD_new, 2);
    ci_up_new = mean_new + 1.96 * std(wellPSD_new, 0, 2) / sqrt(n_new);
    ci_lo_new = mean_new - 1.96 * std(wellPSD_new, 0, 2) / sqrt(n_new);

    wellPSD_old = results(pp).wellPSD_old;
    mean_old  = mean(wellPSD_old, 2);
    n_old     = size(wellPSD_old, 2);
    ci_up_old = mean_old + 1.96 * std(wellPSD_old, 0, 2) / sqrt(n_old);
    ci_lo_old = mean_old - 1.96 * std(wellPSD_old, 0, 2) / sqrt(n_old);

    y_min_global = min(y_min_global, min([10*log10(ci_lo_new); 10*log10(ci_lo_old)]));
    y_max_global = max(y_max_global, max([10*log10(ci_up_new); 10*log10(ci_up_old)]));

    fprintf('✅ %s pre-computed.\n', panels(p).tag);
end

y_min_global = floor(y_min_global - 2);
y_max_global = -110;  % forced as Oskari suggested
fprintf('Global Y limits: [%.1f, %.1f] dB/Hz\n', y_min_global, y_max_global);

% --- STEP 2: Plot using stored results ---
fig = figure('Visible','off','Position',[100 100 1800 450]);
tl  = tiledlayout(1, 4, 'TileSpacing','compact','Padding','loose');

for pp = 1:4
    p   = results(pp).panel_idx;

    wellPSD_new = results(pp).wellPSD_new;
    wellPSD_old = results(pp).wellPSD_old;
    f_plot      = results(pp).f_plot;

    mean_new  = mean(wellPSD_new, 2);
    n_new     = size(wellPSD_new, 2);
    ci_up_new = mean_new + 1.96 * std(wellPSD_new, 0, 2) / sqrt(n_new);
    ci_lo_new = mean_new - 1.96 * std(wellPSD_new, 0, 2) / sqrt(n_new);

    mean_old  = mean(wellPSD_old, 2);
    n_old     = size(wellPSD_old, 2);
    ci_up_old = mean_old + 1.96 * std(wellPSD_old, 0, 2) / sqrt(n_old);
    ci_lo_old = mean_old - 1.96 * std(wellPSD_old, 0, 2) / sqrt(n_old);

    nexttile;
    hold on;

    fill([f_plot; flipud(f_plot)], ...
         [10*log10(ci_up_new); flipud(10*log10(ci_lo_new))], ...
         c_new, 'FaceAlpha', 0.15, 'EdgeColor', 'none', 'HandleVisibility', 'off');
    plot(f_plot, 10*log10(mean_new), 'Color', c_new, 'LineWidth', 2, 'DisplayName', 'New');

    fill([f_plot; flipud(f_plot)], ...
         [10*log10(ci_up_old); flipud(10*log10(ci_lo_old))], ...
         c_old, 'FaceAlpha', 0.15, 'EdgeColor', 'none', 'HandleVisibility', 'off');
    plot(f_plot, 10*log10(mean_old), 'Color', c_old, 'LineWidth', 2, 'DisplayName', 'Old');

    xlabel('Frequency (Hz)');
    ylabel('Power (dB/Hz)');
    title(panels(p).DIV_label);
    ylim([y_min_global y_max_global]);
    legend show;
    grid on;
    hold off;

end

title(tl, 'LFP PSD: New vs Old across DIVs (mean ± 95% CI)', 'FontSize', 13);

exportgraphics(fig, fullfile(fig2A_folder, 'Subplot_LFP_PSD_NewVsOld_4DIV.png'), 'Resolution', 300);
savefig(fig,        fullfile(fig2A_folder, 'Subplot_LFP_PSD_NewVsOld_4DIV.fig'));
close(fig);
disp('✅ Figure 2A saved.');

%% PSD Function
% step 1: for each well it checks the active electrode list, if the well
% doesn't exixt or doesn't have enough active electrodes: skip.
% step 2 : for each 'active'  wells: for each active electrode into the well: LFP extraction, PSD
% (pwelch) and store PSDs (f<250 Hz) into elecPSD
% step 3: elecPSD [nFreq × nElectrodi] → mean → PSD well [nFreq × 1]
% step 4: wellPSD [:, end+1] = PSD well
% wellPSD [nFreq × nWells_valide]------each column is the average PSD for a
% well with n_active_electrodes > th

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
%%
% Problema con DIV 55: old curva bassissima allora introduco min_active ossia il numero minimo di elettrodi attivi per calcolare la PSD.



%% ===================== BLOCK 5: REPRESENTATIVE ELECTRODE SELECTION =====================

min_active_electrodes = 3;
ref_panel             = 1;  % DIV60 — highest DIV, most stable activity
tag                   = panels(ref_panel).tag;

% panels_for_common     = panels(1:3);  % DIV60, DIV55, DIV53 — exclude DIV48 for New
panels_for_common = panels;  % all DIVs

[b_new,  a_new]  = butter(3, lfp_cut/(recordings.(tag).sf_new/2),  'low');
[b_old1, a_old1] = butter(3, lfp_cut/(recordings.(tag).sf_old1/2), 'low');
[b_old2, a_old2] = butter(3, lfp_cut/(recordings.(tag).sf_old2/2), 'low');

% --- NEW ---
[repWell_new, repElec_new] = selectRepresentativeElectrode(...
    recordings.(tag).new, wells_new, activeElec.(tag).new, ...
    b_new, a_new, recordings.(tag).sf_new, ...
    window_psd, noverlap_psd, nfft_psd, lfp_cut, min_active_electrodes, ...
    activeElec, panels_for_common, 'new');

% --- OLD1 ---
[repWell_old1, repElec_old1] = selectRepresentativeElectrode(...
    recordings.(tag).old1, wells_old1, activeElec.(tag).old1, ...
    b_old1, a_old1, recordings.(tag).sf_old1, ...
    window_psd, noverlap_psd, nfft_psd, lfp_cut, min_active_electrodes, ...
    activeElec, panels_for_common, 'old1');

% --- OLD2 ---
[repWell_old2, repElec_old2] = selectRepresentativeElectrode(...
    recordings.(tag).old2, wells_old2, activeElec.(tag).old2, ...
    b_old2, a_old2, recordings.(tag).sf_old2, ...
    window_psd, noverlap_psd, nfft_psd, lfp_cut, min_active_electrodes, ...
    activeElec, panels_for_common, 'old2');

% --- Pick best Old between old1 and old2 ---
idx_old1 = find(strcmp(cellstr([activeElec.(tag).old1.well]), repWell_old1));
idx_old2 = find(strcmp(cellstr([activeElec.(tag).old2.well]), repWell_old2));
n_old1   = activeElec.(tag).old1(idx_old1).nActiveElectrodes;
n_old2   = activeElec.(tag).old2(idx_old2).nActiveElectrodes;

if n_old1 >= n_old2
    repWell_old = char(repWell_old1);
    repElec_old = char(repElec_old1);
    repSys_old  = 'old1';
else
    repWell_old = char(repWell_old2);
    repElec_old = char(repElec_old2);
    repSys_old  = 'old2';
end

repWell_new = char(repWell_new);
repElec_new = char(repElec_new);

fprintf('NEW  → well: %s, electrode: %s\n', repWell_new, repElec_new);
fprintf('OLD  → well: %s, electrode: %s (%s)\n', repWell_old, repElec_old, repSys_old);

% --- Save to file ---
fid = fopen(fullfile(outputFolder, 'representative_electrode_info.txt'), 'w');
fprintf(fid, 'NEW  → well: %s, electrode: %s\n', repWell_new, repElec_new);
fprintf(fid, 'OLD  → well: %s, electrode: %s (%s)\n', repWell_old, repElec_old, repSys_old);
fclose(fid);
disp('✅ Representative electrode selection completed.');

%% ===================== HELPER FUNCTION =====================

function [repWell, repElec] = selectRepresentativeElectrode(rec, wells, activeElecPerWell, b, a, sf, window_psd, noverlap_psd, nfft_psd, lfp_cut, min_active, allActiveElec, allPanels, system)

    wellPSDs       = {};
    wellNames      = {};
    wellCommonElec = {};

    for w = 1:length(wells)
        wName = wells{w};
        if ~isfield(rec, wName), continue; end

        wellIdx = find(strcmp(cellstr([activeElecPerWell.well]), wName));
        if isempty(wellIdx), continue; end
        activeNames = activeElecPerWell(wellIdx).activeElectrodes;
        if length(activeNames) < min_active, continue; end

        % Find electrodes active in ALL DIVs
        commonElec = activeNames;
        for p = 1:length(allPanels)
            tag  = allPanels(p).tag;
            wIdx = find(strcmp(cellstr([allActiveElec.(tag).(system).well]), wName));
            if isempty(wIdx)
                commonElec = {};
                break
            end
            commonElec = intersect(commonElec, allActiveElec.(tag).(system)(wIdx).activeElectrodes);
        end

        if isempty(commonElec), continue; end

        fprintf('  Well %s (%s): %d electrodes active in all DIVs → %s\n', ...
            wName, system, length(commonElec), strjoin(commonElec, ', '));

        % Compute mean PSD using only common electrodes
        elecPSD = [];
        for e = 1:length(commonElec)
            eName = char(commonElec{e});
            if ~isfield(rec.(wName), eName), continue; end
            data     = filtfilt(b, a, rec.(wName).(eName));
            [pxx, f] = pwelch(data, window_psd, noverlap_psd, nfft_psd, sf);
            idxF     = f <= lfp_cut;
            if isempty(elecPSD)
                elecPSD = zeros(sum(idxF), length(commonElec));
            end
            elecPSD(:, e) = pxx(idxF);
        end

        if isempty(elecPSD), continue; end

        wellPSDs{end+1}       = mean(elecPSD, 2);
        wellNames{end+1}      = wName;
        wellCommonElec{end+1} = commonElec;
    end

    if isempty(wellPSDs)
        error('No well has electrodes active in all DIVs for system %s. Lower min_active.', system);
    end

    fprintf('\n  Candidate wells: %s\n', strjoin(wellNames, ', '));

    % Select well closest to global mean
    globalMean = mean(cat(2, wellPSDs{:}), 2);
    distances  = cellfun(@(p) norm(p - globalMean), wellPSDs);
    [~, bestW] = min(distances);
    repWell    = wellNames{bestW};
    commonElec = wellCommonElec{bestW};

    fprintf('  → Representative well: %s\n', repWell);

    % Select most representative electrode among common ones
    elecPSDs   = [];
    validNames = {};

    for e = 1:length(commonElec)
        eName = char(commonElec{e});
        if ~isfield(rec.(repWell), eName), continue; end
        data     = filtfilt(b, a, rec.(repWell).(eName));
        [pxx, f] = pwelch(data, window_psd, noverlap_psd, nfft_psd, sf);
        idxF     = f <= lfp_cut;
        if isempty(elecPSDs)
            elecPSDs = zeros(sum(idxF), length(commonElec));
        end
        elecPSDs(:, e) = pxx(idxF);
        validNames{end+1} = eName;
    end

    if isempty(validNames)
        error('No valid electrodes found in well %s for system %s.', repWell, system);
    end

    wellMean   = mean(elecPSDs, 2);
    distances  = arrayfun(@(e) norm(elecPSDs(:,e) - wellMean), 1:size(elecPSDs,2));
    [~, bestE] = min(distances);
    repElec    = validNames{bestE};

    fprintf('  → Representative electrode: %s\n', repElec);

end

%% ===================== FIGURE 2C: 8x4 RAW + LFP + SMOOTHED + SPECTROGRAM =====================
%manual choice for graph quality
repSys_old  = 'old1';
repWell_old = 'F5';
repElec_old = 'E11';



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
%% ===================== FIGURE 2B: Total LFP Power vs DIV =====================

fig2B_folder = fullfile(outputFolder, 'LFP_PSD', 'FIGURE2B');
if ~exist(fig2B_folder, 'dir'), mkdir(fig2B_folder); end

% --- Collect total power per well per DIV ---
% Each entry = mean power across active electrodes of one well (linear scale)

totalPow_new = zeros(4, 1);   % mean across wells per DIV
totalPow_old = zeros(4, 1);
ci_new       = zeros(4, 1);   % 95% CI half-width
ci_old       = zeros(4, 1);
n_new_wells  = zeros(4, 1);
n_old_wells  = zeros(4, 1);
DIV_values   = [48, 53, 55, 60];   % x axis — adjust if needed

for p = 1:4
    tag = panels(p).tag;

    % --- Filter coefficients ---
    [b_new,  a_new]  = butter(3, lfp_cut/(recordings.(tag).sf_new/2),  'low');
    [b_old1, a_old1] = butter(3, lfp_cut/(recordings.(tag).sf_old1/2), 'low');
    [b_old2, a_old2] = butter(3, lfp_cut/(recordings.(tag).sf_old2/2), 'low');

    % --- Well-level PSDs ---
    wellPSD_new  = computeWellPSD(recordings.(tag).new,  wells_new,  activeElec.(tag).new,  b_new,  a_new,  recordings.(tag).sf_new,  window_psd, noverlap_psd, nfft_psd, lfp_cut, min_active_electrodes);
    wellPSD_old1 = computeWellPSD(recordings.(tag).old1, wells_old1, activeElec.(tag).old1, b_old1, a_old1, recordings.(tag).sf_old1, window_psd, noverlap_psd, nfft_psd, lfp_cut, min_active_electrodes);
    wellPSD_old2 = computeWellPSD(recordings.(tag).old2, wells_old2, activeElec.(tag).old2, b_old2, a_old2, recordings.(tag).sf_old2, window_psd, noverlap_psd, nfft_psd, lfp_cut, min_active_electrodes);
    % Pool old1 + old2
    wellPSD_old = [wellPSD_old1, wellPSD_old2];

    % --- Total power per well = integral of PSD (trapz in linear scale) ---
    [~, f] = pwelch(zeros(nfft_psd,1), window_psd, noverlap_psd, nfft_psd, recordings.(tag).sf_new);
    f_plot = f(f <= lfp_cut);

    % trapz integrates PSD over frequency → total power per well (V²)
    pow_new_wells = arrayfun(@(w) trapz(f_plot, wellPSD_new(:,w)), 1:size(wellPSD_new,2));
    pow_old_wells = arrayfun(@(w) trapz(f_plot, wellPSD_old(:,w)), 1:size(wellPSD_old,2));

    % --- Mean and 95% CI across wells ---
    n_new_wells(p)  = length(pow_new_wells);
    n_old_wells(p)  = length(pow_old_wells);

    totalPow_new(p) = mean(pow_new_wells);
    totalPow_old(p) = mean(pow_old_wells);

    ci_new(p) = 1.96 * std(pow_new_wells) / sqrt(n_new_wells(p));
    ci_old(p) = 1.96 * std(pow_old_wells) / sqrt(n_old_wells(p));

end

% --- Convert to dB ---
totalPow_new_dB = 10*log10(totalPow_new);
totalPow_old_dB = 10*log10(totalPow_old);

% CI in dB (propagated asymmetrically)
ci_up_new_dB = 10*log10(totalPow_new + ci_new) - totalPow_new_dB;
ci_lo_new_dB = totalPow_new_dB - 10*log10(max(totalPow_new - ci_new, eps));
ci_up_old_dB = 10*log10(totalPow_old + ci_old) - totalPow_old_dB;
ci_lo_old_dB = totalPow_old_dB - 10*log10(max(totalPow_old - ci_old, eps));

% --- Plot ---
fig = figure('Visible','off','Position',[600 300 700 500]);
hold on;

% Shaded CI - NEW
fill([DIV_values, fliplr(DIV_values)], ...
     [totalPow_new_dB' + ci_up_new_dB', fliplr(totalPow_new_dB' - ci_lo_new_dB')], ...
     c_new, 'FaceAlpha', 0.15, 'EdgeColor', 'none', 'HandleVisibility', 'off');

% Shaded CI - OLD
fill([DIV_values, fliplr(DIV_values)], ...
     [totalPow_old_dB' + ci_up_old_dB', fliplr(totalPow_old_dB' - ci_lo_old_dB')], ...
     c_old, 'FaceAlpha', 0.15, 'EdgeColor', 'none', 'HandleVisibility', 'off');

% Lines + markers
plot(DIV_values, totalPow_new_dB, '-o', 'Color', c_new, 'LineWidth', 2, ...
     'MarkerFaceColor', c_new, 'MarkerSize', 7, 'DisplayName', 'New');
plot(DIV_values, totalPow_old_dB, '-o', 'Color', c_old, 'LineWidth', 2, ...
     'MarkerFaceColor', c_old, 'MarkerSize', 7, 'DisplayName', 'Old');

xlabel('DIV');
ylabel('Total LFP Power (dB)');
title('Total LFP Power vs DIV — New vs Old (mean ± 95% CI)');
xticks(DIV_values);
legend show;
grid on;
hold off;

exportgraphics(fig, fullfile(fig2B_folder, 'TotalLFPPower_vs_DIV.png'), 'Resolution', 300);
savefig(fig,        fullfile(fig2B_folder, 'TotalLFPPower_vs_DIV.fig'));
close(fig);
disp('✅ Figure 2B saved.');