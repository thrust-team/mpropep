%% getID and getPropellantFromID test
% This function assesses if both functions work as expected

clc; clear all;

addpath("../io")

propellantID = 1000;
good = true;
substancesWithAliases = string([]);
disp("checking ID...")
while true
    
    propellantID = propellantID + 1;
%     fprintf("ID: %i - ok\n",propellantID)
    propellantName = getPropellantFromID(propellantID);
    propellantIDCheck = getID(propellantName);
      
    % fprintf("%i %s %i\n", propellantID, propellantName, propellantIDCheck);
    if ~(propellantIDCheck == propellantID)
        good = false;
        substancesWithAliases(end+1) = propellantName;
        warning("ID: %i - %s did not match\n", propellantID, propellantName)
    end
    
    % TODO: 1st commandment is never to hardcode stuff, yet here i am
    % transgressing - lol
    if propellantID == 1051
        break
    end
end
if ~good
    for i = 1:length(substancesWithAliases)
        substancesWithAliases(i) = " - " + substancesWithAliases(i)+newline;
    end
    warning("these substances have two or more aliases: \n%s",join(substancesWithAliases,''))
else
    fprintf("no substances have aliases\n")
end