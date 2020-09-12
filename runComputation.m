function [] = runComputation(inputPath, outputPath)
    command = ['cd cpropep && cpropep -f ', inputPath, ' -o ', outputPath];
    [ ~ , ~ ] = dos(command);
end