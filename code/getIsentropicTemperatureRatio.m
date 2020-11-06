function temperature = getIsentropicTemperatureRatio(k, M)
    temperature = 1 / ( 1 + ( ( k - 1 ) / 2 ) * M ^ 2);
end