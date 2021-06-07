clear all; clc

mkdir .mpropep
mpropepPath = pwd;

oxidantID = 657; % Dinitrogen monoxide
fuelID = 1032; % Paraffin
OFRatio = 7;
pressure = 50e5;
expansionRatio = 5;
listPropellantID = [oxidantID fuelID];
listMass = [OFRatio 1]*1e-3;
writeInputFile(listPropellantID, listMass, 'EQ_AR', pressure, expansionRatio, '')
runComputation('', '', mpropepPath);
output = readOutputFile('');
flameTemperature = getParamFromOutput(2, 'flame', 'EQ_AR', output);
characteristicVelocity = getParamFromOutput(2, 'c*', 'EQ_AR', output);