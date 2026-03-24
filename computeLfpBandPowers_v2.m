function lfpBandResults = computeLfpBandPowers_v2(lfpPsdResults)
% COMPUTELFPBANDPOWERS Compute absolute & relative power in standard frequency bands
%
% INPUT:
%   lfpPsdResults - struct array with fields:
%       .well        - well name
%       .psd_all     - PSD matrix (freq points × active electrodes)
%       .frequency   - frequency vector
%       .mean_psd    - mean PSD across electrodes
%       .electrodes  - active electrode names
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

nWells         = length(lfpPsdResults);
lfpBandResults = struct;

for w = 1:nWells

    lfpBandResults(w).well        = lfpPsdResults(w).well;
    lfpBandResults(w).electrodes  = lfpPsdResults(w).electrodes;
    lfpBandResults(w).nElectrodes = length(lfpPsdResults(w).electrodes);

    psd = lfpPsdResults(w).psd_all;   % freq × electrodes
    f   = lfpPsdResults(w).frequency; % frequency vector

    if isempty(psd)
        warning('Skipping well %s: no active electrodes', lfpPsdResults(w).well);
        lfpBandResults(w).bandPower.abs = struct();
        lfpBandResults(w).bandPower.rel = struct();
        continue
    end

    totalPower = trapz(f, psd);  % integration along freq dimension

    absPower = struct();
    relPower = struct();
    bandNames = fieldnames(bands);

    for b = 1:length(bandNames)
        band   = bandNames{b};
        fRange = bands.(band);

        idx = f >= fRange(1) & f <= fRange(2);

        bandPowerElectrodes = trapz(f(idx), psd(idx,:));

        absPower.(band) = mean(bandPowerElectrodes);
        relPower.(band) = absPower.(band) / mean(totalPower);
    end

    lfpBandResults(w).bandPower.abs = absPower;
    lfpBandResults(w).bandPower.rel = relPower;

end
end