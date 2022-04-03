%% Gasdynamics
% This function computes the temperature ratio T/T0 for the isentropic flow

function TemperatureRatio = ...
    getIsentropicTemperatureRatio(SpecificHeatRatio, MachNumber)

    % Shapiro 1953, Ch. 4, page 83 eq. 4.14a
    f = @(k, M) 1+((k-1)/2)*M^2; % f = T0/T(k,M)
    
    % Generally T/T0 is more useful
    TemperatureRatio = 1/f(SpecificHeatRatio, MachNumber);
end