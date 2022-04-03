%% Gasdynamics
% This function computes the area ratio A/A* for the isentropic flow

function AreaRatio = ...
    getIsentropicAreaRatio(SpecificHeatRatio, MachNumber)

    % Shapiro 1953, Ch. 4, p. 86, eq. (4.19)
    f = @(k, M) 1/M*((2+(k-1)*M^2)/(k+1))^((k+1)/(2*(k-1)));

    AreaRatio = f(SpecificHeatRatio, MachNumber);
end