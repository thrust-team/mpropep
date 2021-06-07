function [] = runComputation(inputPath, outputPath, mpropepPath)
    workPath = pwd;
    
%     fprintf('%s\n', workPath);

    if inputPath == ""
        inputPath = '.mpropep\input.txt';
    end
    
    if outputPath == ""
        outputPath = '.mpropep\output.txt';
    end

    command = ['cd ', mpropepPath, '\cpropep\ && cpropep', ...
               ' -f "', workPath, '\', inputPath, '"' ...
               ' -o "', workPath, '\', outputPath, '"'];
%     fprintf('%s\n', command);
    [~,~] = dos(command);
end