clear all
    
listPropellantID = [657 1032];
propellantNumber = length(listPropellantID);

inputPath = 'input.txt';
outputPath = 'output.txt';

oxidizerDensity = 688; % kg/m3 liquid phase at 25C
fuelDensity = 900; % kg/m3

g = 9.80665;

listOF = linspace(2,16, 20);
listCStarEQ = zeros(1, length(listOF));
listCStarFR = zeros(1, length(listOF));
listCFEQ = zeros(1, length(listOF));
listCFFR = zeros(1, length(listOF));
density = (fuelDensity + oxidizerDensity.*listOF)./(1 + listOF);

%%
i = 1;
for OF = listOF
    listMass = [OF 1]*1e-3;

    writeInputFile(listPropellantID, listMass, 'EQ_AR', 50e5, 5)
    runComputation(inputPath, outputPath);
    output = readOutputFile(outputPath);
    
    listCStarEQ(i) = getParamFromOutput(propellantNumber, 'c*', 'EQ_AR', output);
    listCFEQ(i) = getParamFromOutput(propellantNumber, 'cF', 'EQ_AR', output);
    
    writeInputFile(listPropellantID, listMass, 'FR_AR', 50e5, 5)
    runComputation(inputPath, outputPath);
    output = readOutputFile(outputPath);
    
    listCStarFR(i) = getParamFromOutput(propellantNumber, 'c*', 'EQ_AR', output);
    listCFFR(i) = getParamFromOutput(propellantNumber, 'cF', 'EQ_AR', output);
	i = i+1;
end

%%
subplot(2,2,1)
plot(listOF,listCStarEQ)
hold on
plot(listOF,listCStarFR)
hold off
axis([listOF(1) listOF(end) 1000 1800])
title('Characteristic Velocity [m/s]')
legend('Shifting Eq.','Frozen')

subplot(2,2,2)
plot(listOF,listCStarEQ.*listCFEQ/g)
hold on
plot(listOF,listCStarFR.*listCFFR/g)
hold off
axis([listOF(1) listOF(end) 100 250])
title('Normalized Specific Impulse [s]')
legend('Shifting Eq.','Frozen')

subplot(2,2,3)
plot(listOF,density)
title('Density [kg/m^3]')

subplot(2,2,4)
plot(listOF,listCStarEQ.*listCFEQ.*density)
hold on
plot(listOF,listCStarFR.*listCFFR.*density)
hold off
title('Volumetric Specific Impulse [Ns/m^3]')
legend('Shifting Eq.','Frozen')