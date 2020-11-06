function thrustCoefficient = getThrustCoefficient( k , e , pa_p0 )
    % k = specificHeatRatio;
    % e = nozzleExpansionCoefficient;
    % pa_p0 = ambientPressureRatio;
    
    M = getMachFromAreaRatio( k , e , 1e3 );
    
    % pe_p0 = exitPressureRatio
    pe_p0 = getIsentropicPressureRatio( k , M );
    
    % Based on Shapiro vol. 1 p. 101 eq. 4.33
    thrustCoefficient = k * sqrt( ...
                                 ( 2 / ( k - 1 ) ) ...
                                 * ( 2 / ( k + 1 ) ) ^ ( ( k + 1 ) / ( k - 1 ) ) ...
                                 * ( 1 - pe_p0 ^ ( ( k - 1 ) / ( k ) ) )   ...
                                 ) ...
                      + e * ( pe_p0 - pa_p0);
end
