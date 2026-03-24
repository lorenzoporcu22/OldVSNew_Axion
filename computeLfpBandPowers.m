function lfpBandResults = computeLfpBandPowers(lfpPsdResults)
% COMPUTELFPBANDPOWERS Compute absolute & relative power in standard frequency bands
%
% INPUT:
%   lfpPsdResults - struct array returned by computeLfpPSD, with fields:
%       .well            - well name
%       .psd             - PSD matrix (freq points × active electrodes)
%       .f               - frequency vector
%       .meanPsd         - mean PSD across electrodes
%       .activeElectrodes- active electrode names
%
% OUTPUT:
%   lfpBandResults - struct array with same length as lfpPsdResults, containing:
%       .well            - well name
%       .electrodes      - active electrodes
%       .nElectrodes     - number of active electrodes
%       .bandPower.abs   - struct with absolute power per band
%       .bandPower.rel   - struct with relative power per band

% Define standard frequency bands (Hz)
bands = struct('delta',[0 4], 'theta',[4 8], 'alpha',[8 12], ...
               'beta',[12 30], 'gamma',[30 100]);

nWells = length(lfpPsdResults);
lfpBandResults = struct;

for w = 1:nWells
    % Basic info
    lfpBandResults(w).well = lfpPsdResults(w).well;
    lfpBandResults(w).electrodes = lfpPsdResults(w).activeElectrodes;
    lfpBandResults(w).nElectrodes = length(lfpPsdResults(w).activeElectrodes);
    
    psd = lfpPsdResults(w).psd; % freq × electrodes
    f   = lfpPsdResults(w).f;   % frequency vector
    
    % Skip wells without active electrodes
    if isempty(psd)
        warning('Skipping well %s: no active electrodes', lfpPsdResults(w).well);
        lfpBandResults(w).bandPower.abs = struct();
        lfpBandResults(w).bandPower.rel = struct();
        continue
    end
    
    % Total power per electrode
    totalPower = trapz(f, psd); % integration along freq dimension
    
    % Initialize structs
    absPower = struct();
    relPower = struct();
    
    bandNames = fieldnames(bands);
    
    for b = 1:length(bandNames)
        band = bandNames{b};
        fRange = bands.(band);
        
        % Find indices within band
        idx = f >= fRange(1) & f <= fRange(2);
        
        % Integrate PSD over band for each electrode
        bandPowerElectrodes = trapz(f(idx), psd(idx,:));
        
        % Average across electrodes
        absPower.(band) = mean(bandPowerElectrodes);
        relPower.(band) = absPower.(band) / mean(totalPower); % relative to total
    end
    
    % Save results
    lfpBandResults(w).bandPower.abs = absPower;
    lfpBandResults(w).bandPower.rel = relPower;
end

end