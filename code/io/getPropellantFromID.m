% Function to find the name of a compound given its identification number
% interpreted by cpropep from propellant.dat file.
% This is useful because usually the ID is passed as a parameter in most
% of the mpropep library.
% Note that the ID is different than the number in the propellant.dat
% text file.
% Some compounds get their name cut because they are multiline in
% propellant.dat.


function propellantName = getPropellantFromID(propellantID)

    addpath("../cpropep/")
    % Check that list.txt is in the folder, otherwise generate it.
    fid = fopen('cpropep/list.txt', 'r');
    if fid == -1
       [ ~ , ~ ] = dos('cd cpropep && cpropep -p > list.txt');
       error('File list.txt was not found and has now been generated.');
    end
    
    % Extract rows
    scan = textscan(fid,'%s','delimiter','\n');
    
    % Close file
    fclose(fid);
    
    % Find the row corresponding to the propellant
    % Note: number 3 is added because 2 rows are skipped and numeration
    % starts with 0
    output = char(scan{1}(propellantID + 3));
    strings = split(output);
    propellantName = lower(char(join(strings(2:end-1),' ')));
    
end