clc
clear
close all

addpath("cpropep")
addpath("gasdynamics\")
addpath("io\")
addpath("num\")

if ~exist(".mpropep","dir")
    mkdir .mpropep
   
end

mpropepPath = pwd;

oxidantID = getID("oxygen (gas)"); % N2O
fuelID = getID("methane"); % Paraffin 0907 (C50H102)
OFRatio = 2;
pressure = 1e5;
expansionRatio = 5;
listPropellantID = [oxidantID fuelID];
listMass = [OFRatio 1]*1e-3;
writeInputFile(listPropellantID, listMass, 'EQ_AR', pressure, expansionRatio, '')
runComputation('', '', mpropepPath);
output = readOutputFile('');
flameTemperature = getParamFromOutput(2, 'flame', 'EQ_AR', output);
characteristicVelocity = getParamFromOutput(2, 'c*', 'EQ_AR', output);
