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