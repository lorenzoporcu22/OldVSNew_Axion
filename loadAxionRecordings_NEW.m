function [recordings, sf, selectedWells, cellLine, DIV] = loadAxionRecordings(rawFilePath, wellsToLoad, cellLine, DIV)
% LOADAXIONRECORDINGS Load Axion MEA recording with optional scripted inputs
%
% INPUTS (all optional, fallback to interactive dialogs if not provided):
%   rawFilePath    - Full path to the .raw file
%   wellsToLoad    - Cell array of well names to load (e.g. {'A1','A2','B1'})
%   cellLine       - Name of the cell line (string)
%   DIV            - Day in vitro (number)
%
% OUTPUTS:
%   recordings     - Structure containing voltage data organized by well and electrode
%   sf             - Sampling frequency (Hz)
%   selectedWells  - Cell array of loaded wells
%   cellLine       - Cell line name
%   DIV            - Day in vitro
%
% EXAMPLE (scripted, no dialogs):
%   [rec, sf, wells, cl, div] = loadAxionRecordings('C:\data\rec.raw', {'A1','B1'}, 'iPSC', 14);
%
% EXAMPLE (interactive, original behavior):
%   [rec, sf, wells, cl, div] = loadAxionRecordings();

%% Select RAW file
if nargin >= 1 && ~isempty(rawFilePath)
    TargetRawFile = rawFilePath;
    if ~isfile(TargetRawFile)
        error('File not found: %s', TargetRawFile);
    end
else
    [files, path] = uigetfile('*.raw*', 'Select Axion RAW file', 'MultiSelect', 'off');
    if isequal(files, 0)
        error('File selection cancelled.');
    end
    TargetRawFile = fullfile(path, files);
end

%% Load Axion file
AxisFileData = AxisFile(TargetRawFile);
sf           = AxisFileData.DataSets.SamplingFrequency;
voltageScale = AxisFileData.DataSets.VoltageScale;
channels     = AxisFileData.ChannelArray.Channels;
disp('Data loading completed successfully.')

%% Detect available wells
allWells = cell(length(channels), 1);
for i = 1:length(channels)
    rowLetter = char('A' + channels(i).WellRow - 1);
    colNumber = channels(i).WellColumn;
    allWells{i} = [rowLetter num2str(colNumber)];
end
availableWells = unique(allWells);

%% Select wells
if nargin >= 2 && ~isempty(wellsToLoad)
    missing = setdiff(wellsToLoad, availableWells);
    if ~isempty(missing)
        error('Wells not found in recording: %s', strjoin(missing, ', '));
    end
    selectedWells = wellsToLoad;
else
    [idx, tf] = listdlg( ...
        'PromptString', 'Select wells to load:', ...
        'ListString',   availableWells, ...
        'SelectionMode','multiple', ...
        'ListSize',     [300 300]);
    if ~tf
        error('No wells selected.');
    end
    selectedWells = availableWells(idx);
end

fprintf('\nSelected wells:\n')
fprintf('%s ', selectedWells{:})
fprintf('\n')

%% Metadata
if nargin >= 3 && ~isempty(cellLine) && nargin >= 4 && ~isempty(DIV)
    % use values passed from script, nothing to do
else
    prompt   = {'Cell line:', 'DIV:'};
    dlgtitle = 'Insert metadata';
    dims     = [1 35];
    definput = {'', '0'};
    answer   = inputdlg(prompt, dlgtitle, dims, definput);
    if isempty(answer)
        error('Metadata not provided.');
    end
    cellLine = answer{1};
    DIV      = str2double(answer{2});
end

%% Load recordings
recordings = struct;
tic

for w = 1:length(selectedWells)

    currentWell  = selectedWells{w};

    idxChannels  = arrayfun(@(c) ...
        strcmp([char('A' + c.WellRow - 1) num2str(c.WellColumn)], currentWell), ...
        channels);

    wellChannels = channels(idxChannels);

    for k = 1:length(wellChannels)

        electrode = [num2str(wellChannels(k).ElectrodeRow) ...
                     num2str(wellChannels(k).ElectrodeColumn)];

        try
            Data = AxisFileData.RawVoltageData.LoadData(currentWell, electrode);
        catch
            warning('Missing electrode %s in well %s', electrode, currentWell)
            continue
        end

        addr = find(~cellfun(@isempty, Data));
        if isempty(addr)
            continue
        end

        voltage = double(Data{addr}.Data) * voltageScale;
        voltage = voltage';

        electrodeField = ['E' electrode];
        recordings.(currentWell).(electrodeField) = voltage;

    end
end

toc

end