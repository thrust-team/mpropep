clear all
    
listPropellantID = [657 1032];
propellantNumber = length(listPropellantID);

inputPath = 'input.txt';
outputPath = 'output.txt';

oxidizerDensity = 688; % kg/m3 liquid phase at 25C
fuelDensity = 900; % kg/m3

listOF = linspace(2,16, 20);
listCStarEQ = zeros(1, length(listOF));
listCStarFR = zeros(1, length(listOF));
listCFEQ = zeros(1, length(listOF));
listCFFR = zeros(1, length(listOF));
% density = fuelDensity .* (1 + listOF);

i = 1;
for OF = listOF
    listMass = [OF 1]*1e-3;

    writeInputFile(listPropellantID, listMass, 'EQ_AR', 50e5, 5)
    runComputation('input.txt', 'output.txt');

    listCStarEQ(i) = readOutputFile(propellantNumber, outputPath, 'c*');
    listCFEQ(i) = readOutputFile(propellantNumber, outputPath, 'cF');
    
    writeInputFile(listPropellantID, listMass, 'FR_AR', 50e5, 5)
    runComputation('input.txt', 'output.txt');

    listCStarFR(i) = readOutputFile(propellantNumber, outputPath, 'c*');
    listCFFR(i) = readOutputFile(propellantNumber, outputPath, 'cF');
	i = i+1;
end

%%
subplot(2,1,1)
plot(listOF,listCStarEQ)
hold on
plot(listOF,listCStarFR)
hold off
axis([listOF(1) listOF(end) 1000 1800])
subplot(2,1,2)
plot(listOF,listCStarEQ.*listCFEQ/9.80665)
hold on
plot(listOF,listCStarFR.*listCFFR/9.80665)
hold off
axis([listOF(1) listOF(end) 100 250])