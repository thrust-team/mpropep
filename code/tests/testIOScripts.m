%% getID and getPropellantFromID test
% This function assesses if both functions work as expected

clc; clear all;

addpath("../io")

propellantID = -1;
while true
    propellantID = propellantID + 1;
    propellantName = getPropellantFromID(propellantID);
    propellantIDCheck = getID(propellantName);
      
    % fprintf("%i %s %i\n", propellantID, propellantName, propellantIDCheck);
    if ~(propellantIDCheck == propellantID)
        fprintf("ID: %i - %s did not match\n", propellantID, propellantName)
    end
    
    % TODO: 1st commandment is never to hardcode stuff
    if propellantID == 1051
        break
    end
end