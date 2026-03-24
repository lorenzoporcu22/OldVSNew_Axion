function activeElectrodesPerWell = detectActiveElectrodes(TargetSpikeFile, duration, th)
% detectActiveElectrodes identifies active electrodes from a spike CSV file
%
% INPUTS:
%   TargetSpikeFile - full path to a CSV file containing spike times with an 'Electrode' column
%   duration        - duration of the recording in seconds (used to compute firing rate)
%   th              - firing rate threshold in Hz to consider an electrode active
%
% OUTPUT:
%   activeElectrodesPerWell - struct array with fields:
%       .well            -> well name (string)
%       .activeElectrodes -> 1×nActive cell array of electrode numbers (numeric) that are active
%       .nActiveElectrodes -> number of active electrodes in the well

%% Read table
T = readtable(TargetSpikeFile);

%% Compute firing rates for each electrode
ElectrodesNames = string(unique(T.Electrode));
firingRates = struct('Electrode', [], 'FiringRate', [], 'Active', []);

for i = 1:length(ElectrodesNames)
    currentElectrode = ElectrodesNames(i);
    idx = find(T.Electrode == currentElectrode);
    firingRate = length(idx) / duration;

    firingRates(i).Electrode = currentElectrode;
    firingRates(i).FiringRate = firingRate;
    firingRates(i).Active = firingRate > th;
end

%% Filter valid electrode names (format: A1_12)
pattern = "^[A-Z]\d+_\d+$";
validIdx = ~cellfun('isempty', regexp(ElectrodesNames, pattern));
validNames = ElectrodesNames(validIdx);
originalIndices = find(validIdx);

parts = split(validNames, "_");
wells = parts(:,1);
electrodes = parts(:,2);  % still strings

%% Build struct of active electrodes per well
uniqueWells = unique(wells);
activeElectrodesPerWell = struct('well', {}, 'activeElectrodes', {}, 'nActiveElectrodes', {});

for i = 1:length(uniqueWells)
    currentWell = uniqueWells(i);
    idx = find(wells == currentWell);

    activeList = {};  % initialize 1×n cell array
    for j = 1:length(idx)
    originalIdx = originalIndices(idx(j));
    if firingRates(originalIdx).Active
        % Save the electrode name as string with "E" prefix
        activeList{end+1} = ['E' char(electrodes(idx(j)))];  % E41 
    end
end

    % Ensure activeList is 1×n (row) even if empty
    activeList = reshape(activeList, 1, []);

    activeElectrodesPerWell(i).well = currentWell;
    activeElectrodesPerWell(i).activeElectrodes = activeList;
    activeElectrodesPerWell(i).nActiveElectrodes = length(activeList);
end

end