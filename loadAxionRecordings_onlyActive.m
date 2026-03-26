function [recordings, sf] = loadAxionRecordings_onlyActive(rawFilePath, wellsToLoad, csvFilePath, duration, threshold, cellLine)
% LOADAXIONRECORDINGS_ONLYACTIVE Load only active electrodes from Axion MEA recording
%
% INPUTS:
%   rawFilePath  - Full path to the .raw file
%   wellsToLoad  - Cell array of well names to load (e.g. {'A1','A2','B1'})
%   csvFilePath  - Full path to the spike list .csv file
%   duration     - Recording duration in seconds (for firing rate computation)
%   threshold    - Firing rate threshold in Hz to consider an electrode active
%   cellLine     - Name of the cell line (string)
%
% OUTPUTS:
%   recordings   - Struct with voltage data organized by well and electrode
%                  (only active electrodes are loaded)
%   sf           - Sampling frequency (Hz)
%
% EXAMPLE:
%   [rec, sf] = loadAxionRecordings_onlyActive('C:\data\rec.raw', {'A1','B1'}, ...
%               'C:\data\rec_spike_list.csv', 600, 0.1, 'TUBA');

%% Step 1: Detect active electrodes from CSV
fprintf('Detecting active electrodes from CSV...\n');
activeElecPerWell = detectActiveElectrodes(csvFilePath, duration, threshold);

% Build a flat list of active electrodes per well for quick lookup
% Format: containers.Map  wellName -> {E11, E12, ...}
activeMap = containers.Map();
for i = 1:length(activeElecPerWell)
    wName = char(activeElecPerWell(i).well);
    activeMap(wName) = activeElecPerWell(i).activeElectrodes;
end

% Report
totalActive = sum([activeElecPerWell.nActiveElectrodes]);
fprintf('Found %d active electrodes across %d wells.\n', totalActive, length(activeElecPerWell));

%% Step 2: Load Axion file
fprintf('Opening .raw file...\n');
if ~isfile(rawFilePath)
    error('File not found: %s', rawFilePath);
end

AxisFileData = AxisFile(rawFilePath);
sf           = AxisFileData.DataSets.SamplingFrequency;
voltageScale = AxisFileData.DataSets.VoltageScale;
channels     = AxisFileData.ChannelArray.Channels;
fprintf('Sampling frequency: %d Hz\n', sf);

%% Step 3: Build well/electrode map from channel array
allWellNames = cell(length(channels), 1);
for i = 1:length(channels)
    rowLetter    = char('A' + channels(i).WellRow - 1);
    colNumber    = channels(i).WellColumn;
    allWellNames{i} = [rowLetter num2str(colNumber)];
end

%% Step 4: Load only active electrodes
recordings = struct();
tic

for w = 1:length(wellsToLoad)
    currentWell = wellsToLoad{w};

    % Check if well has any active electrodes
    if ~isKey(activeMap, currentWell)
        warning('Well %s has no active electrodes, skipping.', currentWell);
        continue
    end

    activeNames = activeMap(currentWell);
    if isempty(activeNames)
        warning('Well %s has no active electrodes, skipping.', currentWell);
        continue
    end

    % Find channels belonging to this well
    idxChannels  = arrayfun(@(c) ...
        strcmp([char('A' + c.WellRow - 1) num2str(c.WellColumn)], currentWell), ...
        channels);
    wellChannels = channels(idxChannels);

    nLoaded = 0;
    for k = 1:length(wellChannels)

        % Build electrode field name (e.g. E41)
        electrode      = [num2str(wellChannels(k).ElectrodeRow) ...
                          num2str(wellChannels(k).ElectrodeColumn)];
        electrodeField = ['E' electrode];

        % Skip if not in active list
        if ~ismember(electrodeField, activeNames)
            continue
        end

        % Load data
        try
            Data = AxisFileData.RawVoltageData.LoadData(currentWell, electrode);
        catch
            warning('Could not load electrode %s in well %s', electrode, currentWell);
            continue
        end

        addr = find(~cellfun(@isempty, Data));
        if isempty(addr), continue; end

        voltage = double(Data{addr}.Data) * voltageScale;
        voltage = voltage';

        recordings.(currentWell).(electrodeField) = voltage;
        nLoaded = nLoaded + 1;
    end

    fprintf('  Well %s: loaded %d / %d active electrodes.\n', ...
        currentWell, nLoaded, length(activeNames));
end

toc
fprintf('✅ Done loading active electrodes for %s.\n', cellLine);

end
