function output = readOutputFile(outputPath)
    % Check that output.txt exists
    fid = fopen(['cpropep/', outputPath], 'r');
    if fid == -1
       error('Output file does not exist.');
    end
    
    % Split output file in cells with line content
    scan = textscan(fid,'%s','delimiter','\n');
    
    % Split in column of cells containing strings
    output = scan{1};