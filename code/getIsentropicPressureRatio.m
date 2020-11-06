function isentropicPressureRatio = getIsentropicPressureRatio(k, M)
    % Based on Shapiro vol. 1 page 83 eq. 4.14b
    isentropicPressureRatio = 1 / ( 1 + ( ( k - 1 ) / 2 ) * M ^ 2) ^ ( k / ( k - 1 ));
end