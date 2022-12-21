function output = readOutputFile(outputPath)
    if outputPath == ""
        outputPath = '.mpropep\output.txt';
    end
    
    % Check that output.txt exists
    fid = fopen(outputPath, 'r');
    if fid == -1
       error('Output file does not exist.');
    end
    
    % Split output file in cells with line content
    scan = textscan(fid,'%s','delimiter','\n');
    
    % Split in column of cells containing strings
    output = scan{1};

    % remove last row (end of file)
    output = output(1:end-1);
    
    % Danger zone
    fclose('all');