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

oxidantID = getID("nitrous oxide"); % N2O
fuelID = getID("paraffin 0907"); % Paraffin 0907 (C50H102)
OFRatio = 2;
pressure = 10e5;
expansionRatio = 5;
listPropellantID = [oxidantID fuelID];
listMass = [OFRatio 1]*1e-3;

mpropepWriteInput(listPropellantID, listMass, 'FR_EP', pressure, 1e5)
mpropepRun();
output = mpropepReadOutput();
temperature = output.chamber.T;