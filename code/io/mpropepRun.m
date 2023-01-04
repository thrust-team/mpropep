function [] = mpropepRun(varargin)

    if mod(length(varargin),2) ~= 0
        error("fields and specifications should always come in pair")
    end

    workPath = pwd;
    
%     fprintf('%s\n', workPath);
    inputPath = '.mpropep\input.txt';
    outputPath = '.mpropep\output.txt';
    mpropepPath = pwd;

    for i = 1:2:length(varargin)
        switch lower(varargin{i})
            case "inputpath"
                inputPath = varargin{i+1};
            case "outputpath"
                outputPath = varargin{i+1};
            case "mpropeppath"
                mpropepPath = varargin{i+1};
            otherwise
                error("option not understood")
        end
    end

    command = ['cd ', mpropepPath, '\cpropep\ && cpropep', ...
               ' -f "', workPath, '\', inputPath, '"' ...
               ' -o "', workPath, '\', outputPath, '"'];
%     fprintf('%s\n', command);
    [status,~] = dos(command);

    if status ~= 0
        error("error occured while running cpropep")
    end
end