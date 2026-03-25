%% Subplot 1x4: LFP PSD New vs Old - 4 DIV panels

%% ===================== USER PARAMETERS =====================

% Wells are fixed across all DIVs
wells_new  = {'A1','A2','A3','A4','A5','A6','A7','A8', ...
              'B1','B2','B3','B4','B5','B6','B7','B8', ...
              'C1','C2','C3','C4','C5','C6','C7','C8'};

wells_old1 = {'F1','F2','F3','F4','F5','F6','F7','F8'};

wells_old2 = {'C1','C2','C3','C4','C5','C6','C7','C8', ...
              'D1','D2','D3','D4','D5','D6','D7','D8'};

cellLine = 'TUBA';

% One panel per DIV — fill in the .raw file paths for each DIV
panels(1).DIV_label    = 'DIV 60'; %59, 60, 60
panels(1).rawFile_new  = 'S:\met_narkilahti_mea_until2025_sto-3678\Sudipta Swarna\2nd Round_045WTs and GreenTUBA\DOM27 161225\108-4504\161225_045WTs & greenTUBA_DOM27(000).raw';
panels(1).rawFile_old1 = 'S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Dravet+OGD_Ropa+Venla_N2894_N2895\DIV60\DIV60\N2894_Dravet.OGD_81-6002_DD1C.N34.N27.TUBA_D60(000).raw';
panels(1).rawFile_old2 = "S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Cortical differentiation DravetExp6_TUBA_DD5A_DD3A_N2905\N2905_Corticaldifferentiation_TUBAN40_DD5AN39_DD3AN38_DIV60(000).raw";

panels(2).DIV_label    = 'DIV 55';% 54, 55, 55
panels(2).rawFile_new  = "S:\met_narkilahti_mea_until2025_sto-3678\Sudipta Swarna\2nd Round_045WTs and GreenTUBA\DOM22 111225\108-4504\111225_045WTs & greenTUBA_DOM22(000).raw";
panels(2).rawFile_old1 = "S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Dravet+OGD_Ropa+Venla_N2894_N2895\DIV55\N2894_Dravet.OGD_81-6002_DD1C.N34.N27.N30_D55(000).raw";
panels(2).rawFile_old2 = "S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Cortical differentiation DravetExp6_TUBA_DD5A_DD3A_N2905\N2905_Corticaldifferentiation_TUBAN40_DD5AN39_DD3AN38_DIV55(000).raw";

panels(3).DIV_label    = 'DIV 53';% 52, 53, 53
panels(3).rawFile_new  = "S:\met_narkilahti_mea_until2025_sto-3678\Sudipta Swarna\2nd Round_045WTs and GreenTUBA\DOM20 091225\108-4504\091225_045WTs & greenTUBA_DOM20(000).raw";
panels(3).rawFile_old1 = "S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Dravet+OGD_Ropa+Venla_N2894_N2895\DIV53\N2894_Dravet.OGD_81-6002_DD1C.N34.N27.N30_D53(000).raw";
panels(3).rawFile_old2 = "S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Cortical differentiation DravetExp6_TUBA_DD5A_DD3A_N2905\N2905_Corticaldifferentiation_TUBAN40_DD5AN39_DD3AN38_DIV53(000).raw";

panels(4).DIV_label    = 'DIV 48'; %47, 49, 48
panels(4).rawFile_new  = "S:\met_narkilahti_mea_until2025_sto-3678\Sudipta Swarna\2nd Round_045WTs and GreenTUBA\DOM15 041225\108-4504\041225_045WTs & greenTUBA_DOM15(000).raw";
panels(4).rawFile_old1 = '"S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Dravet+OGD_Ropa+Venla_N2894_N2895\DIV49\N2894_Dravet.OGD_81-6002_DD1C.N34.N27.N30.ControlBaseline_D49(000).raw"';
panels(4).rawFile_old2 = "S:\met_narkilahti_mea_until2025_sto-3678\Ropa\Cortical differentiation DravetExp6_TUBA_DD5A_DD3A_N2905\N2905_Corticaldifferentiation_TUBAN40_DD5AN39_DD3AN38_DIV48(000).raw";

%% ===================== FIXED PARAMETERS =====================

lfp_cut      = 250;
window_psd   = hamming(4096);
noverlap_psd = 2048;
nfft_psd     = 8192;

c_new = [0.85 0.15 0.15];
c_old = [0.15 0.35 0.85];

outputFolder = 'S:\met_narkilahti_neuro_sto-3700\MEA_data_internship\Lorenzo\OldVSNew';
if ~exist(outputFolder, 'dir'), mkdir(outputFolder); end

%% ===================== MAIN LOOP =====================

fig = figure('Visible','off','Position',[100 100 1800 450]);
t   = tiledlayout(1, 4, 'TileSpacing','compact','Padding','loose');

for p = 1:4

    %% --- Load recordings ---
    [rec_new,  sf_new,  ~, ~, ~] = loadAxionRecordings_auto(panels(p).rawFile_new,  wells_new,  cellLine, 0);
    [rec_old1, sf_old1, ~, ~, ~] = loadAxionRecordings_auto(panels(p).rawFile_old1, wells_old1, cellLine, 0);
    [rec_old2, sf_old2, ~, ~, ~] = loadAxionRecordings_auto(panels(p).rawFile_old2, wells_old2, cellLine, 0);

    %% --- LFP filter coefficients ---
    [b_new,  a_new]  = butter(3, lfp_cut/(sf_new/2),  'low');
    [b_old1, a_old1] = butter(3, lfp_cut/(sf_old1/2), 'low');
    [b_old2, a_old2] = butter(3, lfp_cut/(sf_old2/2), 'low');

    %% --- Compute well-level PSDs ---
    wellPSD_new  = computeWellPSD(rec_new,  wells_new,  b_new,  a_new,  sf_new,  window_psd, noverlap_psd, nfft_psd, lfp_cut);
    wellPSD_old1 = computeWellPSD(rec_old1, wells_old1, b_old1, a_old1, sf_old1, window_psd, noverlap_psd, nfft_psd, lfp_cut);
    wellPSD_old2 = computeWellPSD(rec_old2, wells_old2, b_old2, a_old2, sf_old2, window_psd, noverlap_psd, nfft_psd, lfp_cut);

    % Pool Old1 + Old2
    wellPSD_old = [wellPSD_old1, wellPSD_old2];

    %% --- Frequency axis ---
    [~, f] = pwelch(zeros(nfft_psd,1), window_psd, noverlap_psd, nfft_psd, sf_new);
    f_plot = f(f <= lfp_cut);

    %% --- Mean and 95% CI across wells ---
    n_new     = size(wellPSD_new, 2);
    mean_new  = mean(wellPSD_new, 2);
    ci_up_new = mean_new + 1.96 * std(wellPSD_new, 0, 2) / sqrt(n_new);
    ci_lo_new = mean_new - 1.96 * std(wellPSD_new, 0, 2) / sqrt(n_new);

    n_old     = size(wellPSD_old, 2);
    mean_old  = mean(wellPSD_old, 2);
    ci_up_old = mean_old + 1.96 * std(wellPSD_old, 0, 2) / sqrt(n_old);
    ci_lo_old = mean_old - 1.96 * std(wellPSD_old, 0, 2) / sqrt(n_old);

    %% --- Plot panel ---
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
    legend show;
    grid on;
    hold off;

end

title(t, 'LFP PSD: New vs Old across DIVs (mean ± 95% CI)', 'FontSize', 13);

exportgraphics(fig, fullfile(outputFolder, 'Subplot_LFP_PSD_NewVsOld_4DIV.png'), 'Resolution', 300);
savefig(fig, fullfile(outputFolder, 'Subplot_LFP_PSD_NewVsOld_4DIV.fig'));
close(fig);
disp('✅ Subplot 1x4 LFP PSD saved.');

%% ===================== HELPER FUNCTION =====================

function wellPSD = computeWellPSD(rec, wells, b, a, sf, window_psd, noverlap_psd, nfft_psd, lfp_cut)
    wellPSD = [];
    for w = 1:length(wells)
        wName = wells{w};
        if ~isfield(rec, wName), continue; end
        electrodes = fieldnames(rec.(wName));

        elecPSD = [];
        for e = 1:length(electrodes)
            data     = filtfilt(b, a, rec.(wName).(electrodes{e}));
            [pxx, f] = pwelch(data, window_psd, noverlap_psd, nfft_psd, sf);
            idxF     = f <= lfp_cut;
            if isempty(elecPSD)
                elecPSD = zeros(sum(idxF), length(electrodes));
            end
            elecPSD(:, e) = pxx(idxF);
        end

        % Mean across electrodes → single PSD for this well
        wellPSD(:, end+1) = mean(elecPSD, 2);
    end
end

%%%sbagliato perche deve fare la psd solo degli elettrodi attivi...inserire
%%%active electrodes.