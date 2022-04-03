%% Gasdynamics
% This function computes the pressure ratio p/p0 for the isentropic flow

function PressureRatio = ...
    getIsentropicPressureRatio(SpecificHeatRatio, MachNumber)

    % Shapiro 1953, Ch. 4, page 83 eq. 4.14b
    f = @(k, M) (1+((k-1)/2)*M^2)^(k/(k-1)); % f = p0/p(k,M)
    
    % Generally p/p0 is more useful
    PressureRatio = 1/f(SpecificHeatRatio, MachNumber);
end