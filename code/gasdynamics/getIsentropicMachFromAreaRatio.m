%% Gasdynamics
% This function computes the subsonic and supersonic Mach number
% given area ratio A/A* in the isentropic flow

function [SubsonicMach, SupersonicMach] = ...
    getIsentropicMachFromAreaRatio(...
        SpecificHeatRatio, AreaRatio)
    
    % Obvious result
    if AreaRatio == 1
        SubsonicMach = 1;
        SupersonicMach = 1;
        return
    end
    
    % Value check
    if AreaRatio < 1
       error('Area Ratio lower than 1 is not allowed.') ;
    end
    
    % Shapiro 1953, Ch. 4, p. 86, eq. (4.19)
    % modified to be g(k, M, A/A*) = f(k,M) - A/A*
    g = @(k, M, e) 1/M*((2+(k-1)*M^2)/(k+1))^((k+1)/(2*(k-1))) - e;
    
    %% Newton-Raphson to find the zero of g function
    tol = 1e-12;
    
    dg = @(k, M) (2/(k+1))*((M^2-1)/M^2)* ...
                 ((2+(k-1)*M^2)/(k+1))^((k-3)/(2*(1-k)));
    
             
    if AreaRatio < 1e3
        SubsonicMach = ...
            getZeroNewtonRaphson(@(M) g(SpecificHeatRatio, M, AreaRatio), ...
                                 @(M) dg(SpecificHeatRatio, M), ...
                                 1e-3, tol);
        SupersonicMach = ...
            getZeroNewtonRaphson(@(M) g(SpecificHeatRatio, M, AreaRatio), ...
                                 @(M) dg(SpecificHeatRatio, M), ...
                                 10, tol);
        return
    end
    
    % This section better approximates the initial value
    if AreaRatio >= 1e3
        SubsonicMach = ...
            getZeroNewtonRaphson(@(M) g(SpecificHeatRatio, M, AreaRatio), ...
                                 @(M) dg(SpecificHeatRatio, M), ...
                                 AreaRatio^(-1)*10^(-.25), tol);
        SupersonicMach = ...
            getZeroNewtonRaphson(@(M) g(SpecificHeatRatio, M, AreaRatio), ...
                                 @(M) dg(SpecificHeatRatio, M), ...
                                 AreaRatio^(1/9.5)*10^(.5), tol);
        return
    end
    
end