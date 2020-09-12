clear all
    
listPropellantID = [657 1032];
propellantNumber = length(listPropellantID);

inputPath = 'input.txt';
outputPath = 'output.txt';

oxidizerDensity = 688; % kg/m3 liquid phase at 25C
fuelDensity = 900; % kg/m3

listOF = linspace(5.5,8, 20);
characteristicVelocity = zeros(1, length(listOF));
% density = fuelDensity .* (1 + listOF);

i = 1;
for OF = listOF
    listMass = [OF 1]*1e-3;

    writeInputFile(listPropellantID, listMass, 'EQ_AR', 50e5, 5)
    runComputation('input.txt', 'output.txt');

    listCStar(i) = readOutputFile(propellantNumber, outputPath, 'c*');
    listCF(i) = readOutputFile(propellantNumber, outputPath, 'cF');
	i = i+1;
end

% %%
% subplot(2,2,1)
% plot(listOF,listCStar)
% subplot(2,2,2)
% plot(listOF,listCStar.*listCF/9.80665)
% subplot(2,2,3)
% plot(listOF,density);
% subplot(2,2,4)
% plot(listOF,listCStar.*listCF.*density);