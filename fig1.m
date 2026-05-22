%% ============================================================
%  FIGURE 1 - OLD vs NEW system: rasters + spiking metrics
%  ============================================================
%
%  Layout (single figure, 3 rows x 12-tile grid):
%    Row 1: 4 rasters from NEW system  (one per DIV, 3 tiles each)
%    Row 2: 4 rasters from OLD system  (one per DIV, 3 tiles each)
%    Row 3: 3 line plots MFR | BR | NB rate (4 tiles each, centered)
%
%  Inputs:
%    - NEW spike list CSVs (one per DIV)
%    - NEW per-electrode metrics  (SpikeBurstDetailsMEAN, one per DIV)
%    - NEW per-well NB metrics    (spikes_NBStatsMEAN,   one per DIV)
%    - OLD spike list CSVs (one per DIV, old2 / N2905 files)
%    - OLD aggregated metrics file (MEA_all_metrics_CellLine_DIV.csv)
%
%  Notes on units:
%    - MFR ........ Hz                        (both systems)
%    - BR ......... bursts/min (single elec)  (new BurstPerSec * 60;
%                                              old MeanBurstRate_s is already /min)
%    - NB rate .... bursts/min                (new BurstPerSec * 60;
%                                              old NB_Rate_perMin_T already /min)
%
%  Statistics (within NEW only — OLD is pre-aggregated, no per-well data):
%    - Kruskal-Wallis across DIVs (Kruskal & Wallis 1952)
%    - Dunn-Sidak post-hoc (Dunn 1964; Sidak 1967)
%    - Spearman rho DIV vs metric (Spearman 1904)
%    - Linear Mixed Model: metric ~ DIV + (1|well)
%      (Aarts et al. 2014 Nat Neurosci; Trujillo et al. 2019 Cell Stem Cell)
%
%  Between-systems:
%    - Descriptive only: fold-change Old/New per DIV (no inferential test)
%
% ============================================================

clear; clc; close all;

%% ===================== PARAMETERS =====================

% -------- Output --------
OUT_DIR  = 'C:\Users\xhk338\OneDrive - TUNI.fi\Desktop\Figure1';
FIG_NAME = 'Figure1_OldVsNew';

% -------- DIV timepoints (in order) --------
DIVs       = [48 53 55 60];
DIV_LABELS = {'DIV 48','DIV 53','DIV 55','DIV 60'};

% -------- Wells displayed in the raster --------
WELL_NEW = 'A4';   % must be in A1..C8 (TUBA wells on NEW plate)
WELL_OLD = 'D5';   % must be in C1..D8 (TUBA wells on old2/N2905 plate)

% -------- Raster window --------
RASTER_T_START = 60;   % s
RASTER_T_WIN   = 60;   % s

% -------- TUBA wells (NEW system: A1..C8 = 24 wells) --------
TARGET_CELLLINE = 'TUBA';
TUBA_ROWS_NEW   = {'A','B','C'};

% -------- Statistics --------
ALPHA       = 0.05;          % significance threshold for brackets
SHOW_BRACKETS = true;        % draw Dunn-Sidak brackets on metric panels

% -------- Paths: NEW system --------
NEW_DIR = 'C:\Users\xhk338\OneDrive - TUNI.fi\Desktop\data new system';

new_spike_csv = { ...
    fullfile(NEW_DIR, '041225_045WTs & greenTUBA_DOM15(000)_spike_list.csv'), ...
    fullfile(NEW_DIR, '091225_045WTs & greenTUBA_DOM20(000)_spike_list.csv'), ...
    fullfile(NEW_DIR, '111225_045WTs & greenTUBA_DOM22(000)_spike_list.csv'), ...
    fullfile(NEW_DIR, '161225_045WTs & greenTUBA_DOM27(000)_spike_list.csv') };

new_spikeburst_csv = { ...
    fullfile(NEW_DIR, 'N3000_041225_045WTsgreenTUBA_DOM15_SpikeBurstDetailsMEAN.csv'), ...
    fullfile(NEW_DIR, 'N3000_091225_045WTsgreenTUBA_DOM20_SpikeBurstDetailsMEAN.csv'), ...
    fullfile(NEW_DIR, 'N3000_111225_045WTsgreenTUBA_DOM22_SpikeBurstDetailsMEAN.csv'), ...
    fullfile(NEW_DIR, 'N3000_161225_045WTsgreenTUBA_DOM27_SpikeBurstDetailsMEAN.csv') };

new_nbstats_csv = { ...
    fullfile(NEW_DIR, 'N3000_041225_045WTsgreenTUBA_DOM15_spikes_NBStatsMEAN.csv'), ...
    fullfile(NEW_DIR, 'N3000_091225_045WTsgreenTUBA_DOM20_spikes_NBStatsMEAN.csv'), ...
    fullfile(NEW_DIR, 'N3000_111225_045WTsgreenTUBA_DOM22_spikes_NBStatsMEAN.csv'), ...
    fullfile(NEW_DIR, 'N3000_161225_045WTsgreenTUBA_DOM27_spikes_NBStatsMEAN.csv') };

% -------- Paths: OLD system --------
OLD_DIR = 'C:\Users\xhk338\OneDrive - TUNI.fi\Desktop\data old system\data old system';

old_spike_csv = { ...
    fullfile(OLD_DIR, 'N2905_Corticaldifferentiation_TUBAN40_DD5AN39_DD3AN38_DIV48(000)_spike_list.csv'), ...
    fullfile(OLD_DIR, 'N2905_Corticaldifferentiation_TUBAN40_DD5AN39_DD3AN38_DIV53(000)_spike_list.csv'), ...
    fullfile(OLD_DIR, 'N2905_Corticaldifferentiation_TUBAN40_DD5AN39_DD3AN38_DIV55(000)_spike_list.csv'), ...
    fullfile(OLD_DIR, 'N2905_Corticaldifferentiation_TUBAN40_DD5AN39_DD3AN38_DIV60(000)_spike_list.csv') };

old_metrics_csv = fullfile(OLD_DIR, 'MEA_all_metrics_CellLine_DIV.csv');

% -------- Plot styling --------
COL_NEW   = [0.12 0.47 0.71];
COL_OLD   = [0.84 0.19 0.15];
FONT_NAME = 'Arial';
FONT_AX   = 9;
FONT_TI   = 10;
FONT_STAT = 8;
LW        = 1.4;
MARK_SZ   = 5;
RASTER_LW = 0.6;

FIG_W = 12;
FIG_H = 11;

%% ===================== RASTER DATA: NEW =====================
fprintf('Loading raster data (NEW) -- well %s\n', WELL_NEW);
raster_new = cell(1, numel(DIVs));
for d = 1:numel(DIVs)
    fprintf('  DIV %d ... ', DIVs(d));
    raster_new{d} = load_raster_for_well(new_spike_csv{d}, WELL_NEW, ...
                                          RASTER_T_START, RASTER_T_WIN);
    fprintf('%d spikes in window\n', sum(cellfun(@numel, raster_new{d})));
end

%% ===================== RASTER DATA: OLD =====================
fprintf('Loading raster data (OLD) -- well %s\n', WELL_OLD);
raster_old = cell(1, numel(DIVs));
for d = 1:numel(DIVs)
    fprintf('  DIV %d ... ', DIVs(d));
    raster_old{d} = load_raster_for_well(old_spike_csv{d}, WELL_OLD, ...
                                          RASTER_T_START, RASTER_T_WIN);
    fprintf('%d spikes in window\n', sum(cellfun(@numel, raster_old{d})));
end

%% ===================== METRICS: NEW =====================
fprintf('Computing NEW metrics (per TUBA well)...\n');

% well_names_per_div{d} = ordered list of well names for that DIV
new_MFR        = cell(1, numel(DIVs));
new_BR         = cell(1, numel(DIVs));
new_NB         = cell(1, numel(DIVs));
well_names_div = cell(1, numel(DIVs));

for d = 1:numel(DIVs)
    [mfr_w, br_w, wn_burst] = compute_well_metrics_from_perelectrode( ...
        new_spikeburst_csv{d}, TUBA_ROWS_NEW);
    [nb_w, wn_nb]           = compute_nb_rate_per_well( ...
        new_nbstats_csv{d}, TUBA_ROWS_NEW);

    % Match NB-well names to the burst-well ordering (defensive)
    [~, ia, ib] = intersect(wn_burst, wn_nb, 'stable');
    mfr_w = mfr_w(ia);
    br_w  = br_w(ia);
    nb_w  = nb_w(ib);
    wn    = wn_burst(ia);

    new_MFR{d}        = mfr_w;
    new_BR{d}         = br_w * 60;     % /s -> /min
    new_NB{d}         = nb_w * 60;     % /s -> /min
    well_names_div{d} = wn;

    fprintf('  DIV %d: %d TUBA wells\n', DIVs(d), numel(mfr_w));
end

% Per-DIV mean +/- SEM
new_MFR_mu  = cellfun(@(v) mean(v, 'omitnan'), new_MFR);
new_MFR_sem = cellfun(@(v) std(v, 0, 'omitnan')/sqrt(sum(~isnan(v))), new_MFR);
new_BR_mu   = cellfun(@(v) mean(v, 'omitnan'), new_BR);
new_BR_sem  = cellfun(@(v) std(v, 0, 'omitnan')/sqrt(sum(~isnan(v))), new_BR);
new_NB_mu   = cellfun(@(v) mean(v, 'omitnan'), new_NB);
new_NB_sem  = cellfun(@(v) std(v, 0, 'omitnan')/sqrt(sum(~isnan(v))), new_NB);

%% ===================== METRICS: OLD =====================
fprintf('Loading OLD metrics (TUBA only)...\n');
old_T = readtable(old_metrics_csv);
isTUBA = strcmp(strtrim(string(old_T.CellLine)), TARGET_CELLLINE);
old_T  = old_T(isTUBA, :);

old_MFR = nan(1, numel(DIVs));
old_BR  = nan(1, numel(DIVs));
old_NB  = nan(1, numel(DIVs));

for d = 1:numel(DIVs)
    div_str = sprintf('DIV%d', DIVs(d));
    idx = strcmp(strtrim(string(old_T.DIV)), div_str);
    if any(idx)
        old_MFR(d) = old_T.MeanMFR_Hz(find(idx, 1));
        old_BR(d)  = old_T.MeanBurstRate_s(find(idx, 1));   % already /min (mislabeled)
        old_NB(d)  = old_T.NB_Rate_perMin_T(find(idx, 1));
    else
        warning('No OLD TUBA row found for %s', div_str);
    end
end

%% ===================== STATISTICS (within NEW only) =====================
fprintf('\n=== STATISTICS within NEW (n=24 wells per DIV) ===\n');

metrics_data = {new_MFR, new_BR, new_NB};
metric_names = {'MFR', 'BR', 'NB rate'};
metric_units = {'Hz', 'bursts/min', 'NB/min'};
stats = struct();

for m = 1:3
    data_per_div = metrics_data{m};

    % Build long-format vectors with well IDs consistent across DIVs
    y_all = []; div_all = []; well_all = strings(0, 1);
    for d = 1:numel(DIVs)
        v  = data_per_div{d}(:);
        wn = well_names_div{d}(:);
        y_all    = [y_all;   v];                          %#ok<AGROW>
        div_all  = [div_all; repmat(DIVs(d), numel(v), 1)]; %#ok<AGROW>
        well_all = [well_all; string(wn)];                %#ok<AGROW>
    end

    valid    = ~isnan(y_all);
    y_all    = y_all(valid);
    div_all  = div_all(valid);
    well_all = well_all(valid);

    % --- Kruskal-Wallis across DIVs ---
    [p_kw, ~, kw_stats] = kruskalwallis(y_all, div_all, 'off');

    % --- Dunn-Sidak post-hoc ---
    c = multcompare(kw_stats, 'CType', 'dunn-sidak', 'Display', 'off');
    % columns of c: g1, g2, lo, mean_rank_diff, hi, p
    posthoc = struct();
    posthoc.pairs = c(:, 1:2);
    posthoc.p     = c(:, 6);
    posthoc.div_pairs = [DIVs(c(:,1))', DIVs(c(:,2))'];

    % --- Spearman correlation DIV vs metric ---
    [rho, p_sp] = corr(div_all, y_all, 'Type', 'Spearman');

    % --- LMM: y ~ DIV + (1|well) ---
    tbl = table(y_all, div_all, categorical(well_all), ...
                'VariableNames', {'y', 'DIV', 'well'});
    lme   = fitlme(tbl, 'y ~ DIV + (1|well)');
    slope = lme.Coefficients.Estimate(2);
    p_lmm = lme.Coefficients.pValue(2);

    stats(m).name    = metric_names{m};
    stats(m).p_kw    = p_kw;
    stats(m).posthoc = posthoc;
    stats(m).rho     = rho;
    stats(m).p_sp    = p_sp;
    stats(m).slope   = slope;
    stats(m).p_lmm   = p_lmm;

    fprintf('\n%s (%s):\n', metric_names{m}, metric_units{m});
    fprintf('  KW p = %.4g\n', p_kw);
    fprintf('  Spearman rho = %.3f (p = %.4g)\n', rho, p_sp);
    fprintf('  LMM slope    = %.4f per DIV (p = %.4g)\n', slope, p_lmm);
    fprintf('  Dunn-Sidak post-hoc:\n');
    for i = 1:size(c, 1)
        sig_mark = '';
        if posthoc.p(i) < ALPHA, sig_mark = ' *'; end
        fprintf('    DIV%d vs DIV%d: p = %.4g%s\n', ...
                posthoc.div_pairs(i,1), posthoc.div_pairs(i,2), posthoc.p(i), sig_mark);
    end
end

%% ===================== DESCRIPTIVE: BETWEEN-SYSTEM FOLD-CHANGE =====================
fprintf('\n=== BETWEEN-SYSTEM FOLD-CHANGE (Old / New_mean), descriptive only ===\n');
fc_MFR = old_MFR ./ new_MFR_mu;
fc_BR  = old_BR  ./ new_BR_mu;
fc_NB  = old_NB  ./ new_NB_mu;

fprintf('         DIV48    DIV53    DIV55    DIV60\n');
fprintf('  MFR :  %.2fx   %.2fx   %.2fx   %.2fx\n', fc_MFR);
fprintf('  BR  :  %.2fx   %.2fx   %.2fx   %.2fx\n', fc_BR);
fprintf('  NB  :  %.2fx   %.2fx   %.2fx   %.2fx\n', fc_NB);

%% ===================== FIGURE =====================
fprintf('\nBuilding figure...\n');

fig = figure('Color', 'w', 'Units', 'inches', 'Position', [0.5 0.5 FIG_W FIG_H]);
tlo = tiledlayout(fig, 3, 12, 'TileSpacing', 'compact', 'Padding', 'compact');

% ---------- Row 1: NEW rasters ----------
for d = 1:numel(DIVs)
    ax = nexttile(tlo, [1 3]); hold(ax, 'on'); box(ax, 'on');
    plot_raster(ax, raster_new{d}, RASTER_T_START, RASTER_T_WIN, RASTER_LW);
    title(ax, DIV_LABELS{d}, 'FontWeight', 'bold', 'FontSize', FONT_TI);
    if d == 1
        ylabel(ax, sprintf('New system\nwell %s', WELL_NEW), ...
               'FontWeight', 'bold', 'Color', COL_NEW);
    else
        set(ax, 'YTickLabel', []);
    end
    set(ax, 'XTickLabel', []);
    ax.FontName = FONT_NAME; ax.FontSize = FONT_AX;
end

% ---------- Row 2: OLD rasters ----------
for d = 1:numel(DIVs)
    ax = nexttile(tlo, [1 3]); hold(ax, 'on'); box(ax, 'on');
    plot_raster(ax, raster_old{d}, RASTER_T_START, RASTER_T_WIN, RASTER_LW);
    xlabel(ax, 'Time (s)');
    if d == 1
        ylabel(ax, sprintf('Old system\nwell %s', WELL_OLD), ...
               'FontWeight', 'bold', 'Color', COL_OLD);
    else
        set(ax, 'YTickLabel', []);
    end
    ax.FontName = FONT_NAME; ax.FontSize = FONT_AX;
end

% ---------- Row 3: metric line plots ----------
metric_titles_plot = {'MFR', 'Burst rate (single-electrode)', 'Network burst rate'};
new_mu_all  = {new_MFR_mu,  new_BR_mu,  new_NB_mu};
new_sem_all = {new_MFR_sem, new_BR_sem, new_NB_sem};
old_all     = {old_MFR,     old_BR,     old_NB};

for m = 1:3
    ax = nexttile(tlo, [1 4]); hold(ax, 'on'); box(ax, 'on');

    % NEW: mean +/- SEM
    h_new = errorbar(ax, DIVs, new_mu_all{m}, new_sem_all{m}, ...
             '-o', 'Color', COL_NEW, 'MarkerFaceColor', COL_NEW, ...
             'LineWidth', LW, 'MarkerSize', MARK_SZ, 'CapSize', 6, ...
             'DisplayName', 'New (mean \pm SEM, n=24)');

    % OLD: pre-aggregated (no error bar)
    h_old = plot(ax, DIVs, old_all{m}, '-s', 'Color', COL_OLD, ...
         'MarkerFaceColor', COL_OLD, 'LineWidth', LW, ...
         'MarkerSize', MARK_SZ + 1, 'DisplayName', 'Old (DIV mean)');

    xlabel(ax, 'DIV');
    ylabel(ax, metric_units{m});
    title(ax, metric_titles_plot{m}, 'FontWeight', 'bold', 'FontSize', FONT_TI);
    set(ax, 'XTick', DIVs, 'XLim', [DIVs(1)-2 DIVs(end)+2]);
    ax.FontName = FONT_NAME; ax.FontSize = FONT_AX;

    % --- Dunn-Sidak significant brackets (NEW only) ---
    if SHOW_BRACKETS
        add_sig_brackets(ax, DIVs, stats(m).posthoc, ALPHA);
    end

    % --- Stats text (NEW within-system) ---
    txt = sprintf(['NEW: KW p=%.3g\n' ...
                   '\\rho_{Sp}=%.2f (p=%.3g)\n' ...
                   'LMM slope=%.3g (p=%.3g)'], ...
                  stats(m).p_kw, stats(m).rho, stats(m).p_sp, ...
                  stats(m).slope, stats(m).p_lmm);
    text(ax, 0.03, 0.97, txt, 'Units', 'normalized', ...
         'VerticalAlignment', 'top', 'HorizontalAlignment', 'left', ...
         'FontSize', FONT_STAT, 'FontName', FONT_NAME, ...
         'BackgroundColor', [1 1 1 0.7], 'Margin', 2);

    if m == 1
        lg = legend([h_new, h_old], 'Location', 'southeast', 'Box', 'off');
        lg.FontSize = FONT_AX;
    end
end

%% ===================== EXPORT =====================
if ~isfolder(OUT_DIR), mkdir(OUT_DIR); end
fprintf('\nSaving to %s\n', OUT_DIR);
drawnow;

try
    exportgraphics(fig, fullfile(OUT_DIR, [FIG_NAME '.png']), ...
                   'Resolution', 300, 'BackgroundColor', 'white');
    fprintf('  PNG ok\n');
catch ME
    warning('PNG export failed: %s', ME.message);
end

try
    exportgraphics(fig, fullfile(OUT_DIR, [FIG_NAME '.pdf']), ...
                   'ContentType', 'vector', 'BackgroundColor', 'white');
    fprintf('  PDF (vector) ok\n');
catch
    warning('Vector PDF failed, falling back to rasterized PDF...');
    exportgraphics(fig, fullfile(OUT_DIR, [FIG_NAME '.pdf']), ...
                   'ContentType', 'image', 'Resolution', 600, ...
                   'BackgroundColor', 'white');
    fprintf('  PDF (rasterized 600 dpi) ok\n');
end

fprintf('Done.\n');

%% ===================== HELPER FUNCTIONS =====================

function spk = load_raster_for_well(csv_path, well, t_start, t_win)
    t_end = t_start + t_win;
    spk   = cell(1, 16);
    if ~isfile(csv_path)
        warning('Spike list not found: %s', csv_path); return
    end
    opts = detectImportOptions(csv_path, 'NumHeaderLines', 1, ...
                               'ReadVariableNames', false, 'Delimiter', ',');
    opts = setvartype(opts, 'char');
    T    = readtable(csv_path, opts);

    t_str = T{:, 3};
    e_str = T{:, 4};
    t = str2double(t_str);
    valid = ~isnan(t) & ~cellfun(@isempty, e_str);
    t = t(valid); e = e_str(valid);

    prefix = [well, '_'];
    in_well = startsWith(e, prefix);
    t = t(in_well); e = e(in_well);

    in_win = t >= t_start & t <= t_end;
    t = t(in_win); e = e(in_win);

    for k = 1:numel(t)
        code = e{k};
        us = strfind(code, '_');
        if isempty(us), continue; end
        ec = code(us(1)+1:end);
        if numel(ec) < 2, continue; end
        r  = str2double(ec(1));
        c  = str2double(ec(2));
        if isnan(r) || isnan(c) || r<1 || r>4 || c<1 || c>4, continue; end
        spk{(r-1)*4 + c}(end+1) = t(k);
    end
end

function plot_raster(ax, spk, t_start, t_win, lw)
    t_end = t_start + t_win;
    n_total = sum(cellfun(@numel, spk));
    if n_total > 0
        XX = nan(3, n_total); YY = nan(3, n_total);
        col_idx = 0;
        for el = 1:16
            ts = spk{el}(:)';
            if isempty(ts), continue; end
            n = numel(ts);
            cols = col_idx + (1:n);
            XX(1, cols) = ts;       XX(2, cols) = ts;
            YY(1, cols) = el - 0.4; YY(2, cols) = el + 0.4;
            col_idx = col_idx + n;
        end
        plot(ax, XX(:), YY(:), 'Color', [0 0 0], 'LineWidth', lw);
    end
    xlim(ax, [t_start t_end]);
    ylim(ax, [0.5 16.5]);
    set(ax, 'YTick', [1 4 8 12 16], 'YDir', 'reverse');
end

function [mfr_w, br_w, well_names] = compute_well_metrics_from_perelectrode(csv_path, allowed_rows)
    if ~isfile(csv_path)
        warning('Metrics file not found: %s', csv_path);
        mfr_w = []; br_w = []; well_names = {}; return
    end
    T = readtable(csv_path);
    if any(strcmp(T.Properties.VariableNames, 'Row'))
        elec_codes = T.Row;
    else
        elec_codes = T{:, 1};
    end

    n = numel(elec_codes);
    well_of_elec = cell(n, 1);
    for i = 1:n
        c = elec_codes{i};
        us = strfind(c, '_');
        if isempty(us), well_of_elec{i} = ''; continue; end
        well_of_elec{i} = c(1:us(1)-1);
    end

    keep = false(n, 1);
    for i = 1:n
        w = well_of_elec{i};
        if ~isempty(w) && any(strcmp(w(1), allowed_rows))
            keep(i) = true;
        end
    end
    well_of_elec = well_of_elec(keep);
    mfr_e        = T.MFR(keep);
    br_e         = T.BurstPerSec(keep);

    well_names = unique(well_of_elec, 'stable');
    mfr_w = nan(numel(well_names), 1);
    br_w  = nan(numel(well_names), 1);
    for i = 1:numel(well_names)
        m = strcmp(well_of_elec, well_names{i});
        mfr_w(i) = mean(mfr_e(m), 'omitnan');
        br_w(i)  = mean(br_e(m),  'omitnan');
    end
end

function [nb_w, well_names] = compute_nb_rate_per_well(csv_path, allowed_rows)
    if ~isfile(csv_path)
        warning('NB stats file not found: %s', csv_path);
        nb_w = []; well_names = {}; return
    end
    T = readtable(csv_path);
    if any(strcmp(T.Properties.VariableNames, 'Row'))
        wells = T.Row;
    else
        wells = T{:, 1};
    end

    n = numel(wells);
    keep = false(n, 1);
    for i = 1:n
        w = wells{i};
        if ~isempty(w) && any(strcmp(w(1), allowed_rows))
            keep(i) = true;
        end
    end
    nb_w       = T.BurstPerSec(keep);
    well_names = wells(keep);
end

function add_sig_brackets(ax, xpos, posthoc, alpha)
% Draw stacked significance brackets for pairs with p < alpha.
% xpos: vector of x positions (the DIV values).
% posthoc: struct with fields pairs (Nx2), p (Nx1), div_pairs (Nx2).

    sig_idx = find(posthoc.p < alpha);
    if isempty(sig_idx), return; end

    yl = ylim(ax);
    y_range = yl(2) - yl(1);
    base_y  = yl(2) + 0.03 * y_range;
    step_y  = 0.07 * y_range;
    tick_h  = 0.015 * y_range;

    % Sort brackets by span (short first => stacked closer to data)
    spans = abs(posthoc.div_pairs(sig_idx, 2) - posthoc.div_pairs(sig_idx, 1));
    [~, order] = sort(spans, 'ascend');
    sig_idx = sig_idx(order);

    for k = 1:numel(sig_idx)
        i = sig_idx(k);
        x1 = posthoc.div_pairs(i, 1);
        x2 = posthoc.div_pairs(i, 2);
        y  = base_y + (k-1) * step_y;
        plot(ax, [x1 x1 x2 x2], [y-tick_h y y y-tick_h], ...
             'k-', 'LineWidth', 0.8);
        p = posthoc.p(i);
        if p < 0.001
            mark = '***';
        elseif p < 0.01
            mark = '**';
        else
            mark = '*';
        end
        text(ax, (x1+x2)/2, y + 0.005*y_range, mark, ...
             'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
             'FontSize', 10, 'FontWeight', 'bold');
    end

    % Expand ylim to fit brackets
    new_top = base_y + (numel(sig_idx) - 1) * step_y + 0.06 * y_range;
    ylim(ax, [yl(1) max(yl(2), new_top)]);
end