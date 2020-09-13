% Check if a file is present in the designate position.

function [] = fileCheck(fileName)
    fid = fopen(fileName, 'r');
    if fid == -1
       error('Cannot open file: %s', fileName);
    end
end