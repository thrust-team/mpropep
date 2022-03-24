clear all
mkdir .mpropep
mpropepPath = pwd;
inputPath = '.mpropep\input.txt';
outputPath = '.mpropep\output.txt';

IDs = [657 1032]; % id list of propellants
pn = length(IDs); % propellant number

oxidizerDensity = 688; % kg/m3 liquid phase at 25C
fuelDensity = 900; % kg/m3

expansionRatio = 5;

g = 9.80665;

listOF       = linspace(2,    16,   3);
listPressure = linspace(20e5, 50e5, 3);

n = length(listOF);
listCStarEQ = zeros(1, n);
listCStarFR = zeros(1, n);
listCFEQ =    zeros(1, n);
listCFFR =    zeros(1, n);
listTccEQ =   zeros(1, n);
listTccFR =   zeros(1, n);

%% Compute average density vector
density = fuelDensity * 1 ./ ( 1 + listOF ) + oxidizerDensity .* listOF ./ ( 1 + listOF );

%% Computation section
indexPressure = 1;
for pressure = listPressure
    indexOF = 1;
    for OF = listOF
        listMass = [OF 1]*1e-3;

        writeInputFile(IDs, listMass, 'EQ_AR', pressure, expansionRatio, inputPath)
        runComputation(inputPath, outputPath, mpropepPath);
        output = readOutputFile(outputPath);

        listCStarEQ(indexPressure,indexOF) = getParamFromOutput(pn, 'c*',    'EQ_AR', output);
        listCFEQ   (indexPressure,indexOF) = getParamFromOutput(pn, 'cF',    'EQ_AR', output);
        listTccEQ  (indexPressure,indexOF) = getParamFromOutput(pn, 'flame', 'EQ_AR', output);
        
        writeInputFile(IDs, listMass, 'FR_AR', pressure, expansionRatio, inputPath)
        runComputation(inputPath, outputPath, mpropepPath);
        output = readOutputFile(outputPath);

        listCStarFR(indexPressure,indexOF) = getParamFromOutput(pn, 'c*',    'FR_AR', output);
        listCFFR   (indexPressure,indexOF) = getParamFromOutput(pn, 'cF',    'FR_AR', output);
        listTccFR  (indexPressure,indexOF) = getParamFromOutput(pn, 'flame', 'FR_AR', output);
        indexOF = indexOF + 1;
    end
    indexPressure = indexPressure + 1;
end
indexPressure = indexPressure - 1;

%% Plotting section
subplot(2,2,1)
plot(listOF,listCStarEQ(1,:), 'r-')
plot(listOF,listCStarFR(1,:), 'b-')
hold on
for indexOF = 2:indexPressure
plot(listOF,listCStarEQ(indexOF,:), 'r-')
plot(listOF,listCStarFR(indexOF,:), 'b-')
end
legend('','Location', 'best')
plot([NaN NaN], [NaN NaN], 'Color', 'r', 'DisplayName', "Shifting Eq.")
plot([NaN NaN], [NaN NaN], 'Color', 'b', 'DisplayName', "Frozen")
hold off
axis([listOF(1) listOF(end) min(listCStarEQ(1,:))/2 max(listCStarEQ(1,:))*1.5])
title('Characteristic Velocity [m/s] vs OF Ratio')

figure(1)
subplot(2,2,2)
plot(listOF,listCStarEQ(1,:).*listCFEQ(1,:)/g, 'r-')
plot(listOF,listCStarFR(1,:).*listCFFR(1,:)/g, 'b-')
hold on

for indexOF = 2:indexPressure
plot(listOF,listCStarEQ(indexOF,:).*listCFEQ(indexOF,:)/g, 'r-')
plot(listOF,listCStarFR(indexOF,:).*listCFFR(indexOF,:)/g, 'b-')
end
hold off
axis([listOF(1) listOF(end) 100 250])
title('Normalized Specific Impulse [s] vs OF Ratio')

subplot(2,2,3)
plot(listOF,density)
title('Average Propellant Density [kg/m^3]')

subplot(2,2,4)
plot(listOF,listCStarEQ(1,:).*listCFEQ(1,:).*density, 'r-')
plot(listOF,listCStarFR(1,:).*listCFFR(1,:).*density, 'b-')
hold on
for indexOF = 2:indexPressure
plot(listOF,listCStarEQ(indexOF,:).*listCFEQ(indexOF,:).*density, 'r-')
plot(listOF,listCStarFR(indexOF,:).*listCFFR(indexOF,:).*density, 'b-')
end
hold off
title('Volumetric Specific Impulse [Ns/m^3]')
%%
figure(2)
plot(listOF(1),listTccEQ(1,1), 'r-')
plot(listOF(1),listTccFR(1,1), 'b-')
hold on
for indexOF = 1:indexPressure
plot(listOF,listTccEQ(indexOF,:), 'r-')
plot(listOF,listTccFR(indexOF,:), 'b-')
end
hold off
title('Flame Temperature [K]')
