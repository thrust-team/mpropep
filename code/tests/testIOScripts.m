%% getID and getPropellantFromID test
% This function assesses if both functions work as expected

addpath("../io")

propellantID = 0;
while true
    propellantID = propellantID + 1;
    
    disp(propellantID);
    propellantName = getPropellantFromID(propellantID);
    disp(propellantName)
    propellantIDcheck = getID(propellantName);
    disp(propellantIDcheck);
    disp(propellantIDcheck == propellantID);
    if propellantID == 1000
        break;
    end
end