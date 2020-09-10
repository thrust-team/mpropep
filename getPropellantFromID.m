% Function to find the name of a compound given its identification number
% interpreted by cpropep from propellant.dat file.
% This is useful because usually the ID is passed as a parameter in most
% of the mpropep library.
% Note that the ID is different than the number in the propellant.dat
% text file.
% Some compounds get their name cut because they are multiline in
% propellant.dat.

function propellantName = getPropellantFromID(propellantID)
    % Check that cpropep.exe is in the right folder
    fileCheck('cpropep/list.txt');

    % Open file
    fid = fopen('cpropep/list.txt');
    
    % Extract rows
    scan = textscan(fid,'%s','delimiter','\n');
    
    % Close file
    fclose(fid);
    
    % Find the row corresponding to the propellant
    % Note: number 3 is added because 2 rows are skipped and numeration
    % starts with 0
    output = char(scan{1}(propellantID + 3));
    
    % Print result
    propellantName =['Propellant with ID ', num2str(propellantID), ': ', output(6:36)];
end