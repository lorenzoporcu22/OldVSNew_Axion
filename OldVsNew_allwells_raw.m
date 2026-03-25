addpath 'S:\met_narkilahti_neuro_sto-3700\MEA_data_internship\Lorenzo\AxionFileInput\AxionFileLoader'
%% Loading .raw files
%New system's recordings
[recordings_new, sf_new, selectedwells_new, cellLine_new, DIV_new] = loadAxionRecordings();

%Old system's recordings
[recordings_old, sf_old, selectedwells_old, cellLine_old, DIV_old] = loadAxionRecordings();
%%
clearvars -except recordings_new sf_new selectedwells_new cellLine_new DIV_new recordings_old sf_old selectedwells_old cellLine_old DIV_old

%% Folder Management

MainFolder = 'S:\met_narkilahti_neuro_sto-3700\MEA_data_internship\Lorenzo';
if ~exist(MainFolder,'dir')
    mkdir(MainFolder);
end
baseFolder = fullfile(MainFolder,'OldVSNew');
if ~exist(baseFolder,'dir')
    mkdir(baseFolder);
end
% Subfolders for the different analyses
rawPsdFolder = fullfile(baseFolder,'Raw_PSD');
lfpPsdFolder = fullfile(baseFolder,'LFP_PSD');
if ~exist(rawPsdFolder,'dir')
    mkdir(rawPsdFolder);
end
if ~exist(lfpPsdFolder,'dir')
    mkdir(lfpPsdFolder);
end

bandPowerFolder = fullfile(rawPsdFolder,'BandPower_Comparison');
if ~exist(bandPowerFolder,'dir')
    mkdir(bandPowerFolder);
end
otherFolder = fullfile(rawPsdFolder,'Other');
if ~exist(otherFolder,'dir')
    mkdir(otherFolder);
end

%% Raw PSD 
% PSD Parameters
window_psd   = hamming(4096);
noverlap_psd = 2048;
nfft_psd     = 8192;

outputFolder = rawPsdFolder;

%% Old
mean_psd_oldAll = cell(1,length(selectedwells_old));
for w = 1:length(selectedwells_old)

    well_old = selectedwells_old{w};
    electrodes_old = fieldnames(recordings_old.(well_old));
    psd_old = [];

    for e = 1:length(electrodes_old)

        data = recordings_old.(well_old).(electrodes_old{e});
        [pxx,f] = pwelch(data,window_psd,noverlap_psd,nfft_psd,sf_old);
        idx = f <= 3000;
        psd_old(:,e) = pxx(idx);

    end

    mean_psd_old = mean(psd_old,2);
    mean_psd_oldAll{w} = mean_psd_old ; 

    fig1 = figure;
    hold on
    
    nElec_old = length(electrodes_old);
    colors = lines(nElec_old);
    
    for e = 1:nElec_old
        plot(f(idx),10*log10(psd_old(:,e)), 'Color',colors(e,:), 'LineWidth',1 , 'DisplayName',electrodes_old{e});
    end
    
    plot(f(idx),10*log10(mean_psd_old), 'k', 'LineWidth',3 , 'DisplayName', 'Mean');
    legend show
    title(['RAW PSD OLD AXION SYSTEM - Well ' well_old])
    xlabel('Frequency (Hz)')
    ylabel('Power (dB/Hz)')
    grid on
    
    exportgraphics(fig1,fullfile(outputFolder, ['PSD_RAW_OLD_' well_old '.png']),'Resolution',300)
    
    close(fig1)

end
mean_psd_newAll = cell(1,length(selectedwells_new));
% New
for w = 1:length(selectedwells_new)

    well_new = selectedwells_new{w};
    electrodes_new = fieldnames(recordings_new.(well_new));
    psd_new = [];

    for e = 1:length(electrodes_new)

        data = recordings_new.(well_new).(electrodes_new{e});
        [pxx,f] = pwelch(data,window_psd,noverlap_psd,nfft_psd,sf_new);
        idx = f <= 3000;
        psd_new(:,e) = pxx(idx);

    end

    mean_psd_new = mean(psd_new,2);
    mean_psd_newAll{w} = mean_psd_new; 

    fig1 = figure;
    hold on

    nElec_new = length(electrodes_new);
    colors = lines(nElec_new);

    for e = 1:nElec_new
        plot(f(idx),10*log10(psd_new(:,e)),'Color',colors(e,:),'LineWidth',1 ,'DisplayName',electrodes_new{e});
    end

    plot(f(idx),10*log10(mean_psd_new),'k','LineWidth', 3,'DisplayName','Mean');

    legend show
    title(['RAW PSD NEW AXION SYSTEM - Well ' well_new])
    xlabel('Frequency (Hz)')
    ylabel('Power (dB/Hz)')
    grid on

    exportgraphics(fig1,fullfile(outputFolder,...
        ['PSD_RAW_NEW_' well_new '.png']),'Resolution',300)

    close(fig1)

end
%% Overlay PSD of each well
figOverlay = figure; hold on

% Old system (plot each well)
for w = 1:length(mean_psd_oldAll)
    plot(f(idx), 10*log10(mean_psd_oldAll{w}), 'b','LineWidth',1);
end

% New system (plot each well)
for w = 1:length(mean_psd_newAll)
    plot(f(idx), 10*log10(mean_psd_newAll{w}), 'r','LineWidth',1);
end

% Dummy plots 
h1 = plot(NaN,NaN,'b','LineWidth',2); % Old system
h2 = plot(NaN,NaN,'r','LineWidth',2); % New system

xlabel('Frequency (Hz)');
ylabel('Power (dB/Hz)');
title('Overlay of Mean PSDs per Well: Old vs New');  
grid on;
legend([h1 h2], {'Old System','New System'});

% Salvataggio figure
saveas(figOverlay, fullfile(otherFolder,'Overlay_MeanPSD_perWell.png'));
savefig(figOverlay, fullfile(otherFolder,'Overlay_MeanPSD_perWell.fig'));

%% Mean PSD for each system
psd_old_mat = cell2mat(mean_psd_oldAll);  % raws = freq, column = well
psd_new_mat = cell2mat(mean_psd_newAll);

mean_psd_system_old = mean(psd_old_mat,2);
mean_psd_system_new = mean(psd_new_mat,2);

figMeanSystem= figure; hold on
plot(f(idx), 10*log10(mean_psd_system_old), 'b', 'LineWidth',2);
plot(f(idx), 10*log10(mean_psd_system_new), 'r', 'LineWidth',2);
xlabel('Frequency (Hz)');
ylabel('Power (dB/Hz)');
title('Mean PSD per system');
grid on;
legend({'Old System','New System'});
% Save figure
saveas(figMeanSystem, fullfile(otherFolder,'MeanPSD_perSystem.png'));
savefig(figMeanSystem, fullfile(otherFolder,'MeanPSD_perSystem.fig'));

%% ratio Plot
ratioPlot=figure;
plot(f(idx), 10*log10(mean_psd_system_new ./ mean_psd_system_old), 'k','LineWidth',2);
xlabel('Frequency (Hz)');
ylabel('Power difference (dB)');
title('PSD Difference (New / Old)');
grid on;
% Save figure
saveas(ratioPlot, fullfile(otherFolder,'ratioPlot.png'));
savefig(ratioPlot, fullfile(otherFolder,'ratioPlot.fig'));
%% Heatmaps
% Same range for both PSDs
all_psd_db = [10*log10(psd_old_mat(:)); 10*log10(psd_new_mat(:))];
cmin = min(all_psd_db);
cmax = max(all_psd_db);

% Heatmap OLD
Heatmap_old=figure;
imagesc(f(idx), 1:length(mean_psd_oldAll), 10*log10(psd_old_mat'));
xlabel('Frequency (Hz)'); ylabel('Well #');
colorbar; title('PSD Heatmap - Old System');
caxis([cmin cmax]);  % same scale

saveas(Heatmap_old, fullfile(otherFolder,'Heatmap_old.png'));
savefig(Heatmap_old, fullfile(otherFolder,'Heatmap_old.fig'));

% Heatmap NEW
Heatmap_new=figure;
imagesc(f(idx), 1:length(mean_psd_newAll), 10*log10(psd_new_mat'));
xlabel('Frequency (Hz)'); ylabel('Well #');
colorbar; title('PSD Heatmap - New System');
caxis([cmin cmax]);  %same scale 
saveas(Heatmap_new, fullfile(otherFolder,'Heatmap_new.png'));
savefig(Heatmap_new, fullfile(otherFolder,'Heatmap_new.fig'));


%% Calculation and Plots of band powers
% OLD SYSTEM
nWells_old = length(selectedwells_old);
RawPSD_old = struct;

for w = 1:nWells_old
    well_old = selectedwells_old{w};
    electrodes_old = fieldnames(recordings_old.(well_old));
    nElec_old = length(electrodes_old);
    
    % PSD matrix freq x electrodes
    psd_old_well = [];
    for e = 1:nElec_old
        data = recordings_old.(well_old).(electrodes_old{e});
        [pxx,f] = pwelch(data, window_psd, noverlap_psd, nfft_psd, sf_old);
        if isempty(idx)
            idx = f <= f_max;  
        end
        psd_old_well(:,e) = pxx(idx);
    end
    
    RawPSD_old(w).well = well_old;
    RawPSD_old(w).psd  = psd_old_well;                  % freq x electrodes
    RawPSD_old(w).f    = f(idx);
    RawPSD_old(w).meanPsd = mean(psd_old_well,2);      
    RawPSD_old(w).activeElectrodes = electrodes_old;
end


RawBandResult_old = computeLfpBandPowers(RawPSD_old);

% NEW SYSTEM
nWells_new = length(selectedwells_new);
RawPSD_new = struct;

for w = 1:nWells_new
    well_new = selectedwells_new{w};
    electrodes_new = fieldnames(recordings_new.(well_new));
    nElec_new = length(electrodes_new);
    
    % PSD matrix freq x electrodes
    psd_new_well = [];
    for e = 1:nElec_new
        data = recordings_new.(well_new).(electrodes_new{e});
        [pxx,f] = pwelch(data, window_psd, noverlap_psd, nfft_psd, sf_new);
        psd_new_well(:,e) = pxx(idx);  
    end
    
    RawPSD_new(w).well = well_new;
    RawPSD_new(w).psd  = psd_new_well;                  % freq x electrodes
    RawPSD_new(w).f    = f(idx);
    RawPSD_new(w).meanPsd = mean(psd_new_well,2);     
    RawPSD_new(w).activeElectrodes = electrodes_new;
end

RawBandResult_new = computeLfpBandPowers(RawPSD_new);
bands = {'delta','theta','alpha','beta','gamma'};
nBands = length(bands);

%% ABSOLUTE POWER'S PLOT
% OLD
oldAbs = zeros(length(RawBandResult_old), nBands);
for w = 1:length(RawBandResult_old)
    for b = 1:nBands
        oldAbs(w,b) = RawBandResult_old(w).bandPower.abs.(bands{b});
    end
end
meanOldAbs = mean(oldAbs,1);
stdOldAbs  = std(oldAbs,0,1);

% NEW
newAbs = zeros(length(RawBandResult_new), nBands);
for w = 1:length(RawBandResult_new)
    for b = 1:nBands
        newAbs(w,b) = RawBandResult_new(w).bandPower.abs.(bands{b});
    end
end
meanNewAbs = mean(newAbs,1);
stdNewAbs  = std(newAbs,0,1);


% Plot Absolute Power
figAbs = figure; hold on
b = bar(1:nBands, [meanOldAbs; meanNewAbs]', 'grouped');

% Errorbar
ngroups = nBands; nbars = 2;
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth/(2*nbars);
    if i == 1
        errorbar(x, meanOldAbs, stdOldAbs, 'k', 'linestyle','none','LineWidth',1.5);
    else
        errorbar(x, meanNewAbs, stdNewAbs, 'k', 'linestyle','none','LineWidth',1.5);
    end
end

set(gca,'XTick',1:nBands,'XTickLabel',bands);
ylabel('Absolute Power');
title('Comparison of Raw Band Absolute Power: Old vs New System');
legend({'Old System','New System'});
grid on;

% Salvataggio figure Absolute Power
saveas(figAbs, fullfile(bandPowerFolder,'RawBandPower_Absolute.png'));
savefig(figAbs, fullfile(bandPowerFolder,'RawBandPower_Absolute.fig'));

%% RELATIVE POWER'S PLOT
% OLD
oldRel = zeros(length(RawBandResult_old), nBands);
for w = 1:length(RawBandResult_old)
    for b = 1:nBands
        oldRel(w,b) = RawBandResult_old(w).bandPower.rel.(bands{b});
    end
end
meanOldRel = mean(oldRel,1);
stdOldRel  = std(oldRel,0,1);

% NEW
newRel = zeros(length(RawBandResult_new), nBands);
for w = 1:length(RawBandResult_new)
    for b = 1:nBands
        newRel(w,b) = RawBandResult_new(w).bandPower.rel.(bands{b});
    end
end
meanNewRel = mean(newRel,1);
stdNewRel  = std(newRel,0,1);

% Plot Relative Power
figRel = figure; hold on
b = bar(1:nBands, [meanOldRel; meanNewRel]', 'grouped');

% Errorbar
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth/(2*nbars);
    if i == 1
        errorbar(x, meanOldRel, stdOldRel, 'k', 'linestyle','none','LineWidth',1.5);
    else
        errorbar(x, meanNewRel, stdNewRel, 'k', 'linestyle','none','LineWidth',1.5);
    end
end

set(gca,'XTick',1:nBands,'XTickLabel',bands);
ylabel('Relative Power');
title('Comparison of Raw Band Relative Power: Old vs New System');
legend({'Old System','New System'});
grid on;

saveas(figRel, fullfile(bandPowerFolder,'RawBandPower_Relative.png'));
savefig(figRel, fullfile(bandPowerFolder,'RawBandPower_Relative.fig'));