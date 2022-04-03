clear all
mkdir .mpropep
mpropepPath = pwd;
inputPath = '.mpropep\input.txt';
outputPath = '.mpropep\output.txt';

addpath('io')
addpath('gasynamics')
addpath('num')

IDs = [657 1032]; % id list of propellants
pn = length(IDs); % number of propellants

oxidizerDensity = 688; % kg/m3 liquid phase at 25C
fuelDensity = 900; % kg/m3

expansionRatio = 5;

g = 9.80665;

listOF       = linspace(5,    15,   31);
listPressure = linspace(20e5, 50e5, 31);

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
tic
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
toc

%% Plotting section
figure(1)
subplot(2,2,1)

plot(NaN,NaN)
hold on
for indexOF = 1:indexPressure
    plot(listOF,listCStarEQ(indexOF,:), 'r-')
    plot(listOF,listCStarFR(indexOF,:), 'b-')
end
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-r');
h(2) = plot(NaN,NaN,'-b');
legend(h, 'Shifting Eq.','Frozen Eq.');
xlabel('OF Ratio')
ylabel('Characteristic Velocity [m/s]')
hold off

subplot(2,2,2)

plot(NaN,NaN)
hold on
for indexOF = 1:indexPressure
    plot(listOF,listCStarEQ(indexOF,:).*listCFEQ(indexOF,:)/g, 'r-')
    plot(listOF,listCStarFR(indexOF,:).*listCFFR(indexOF,:)/g, 'b-')
end
hold off
xlabel('OF Ratio')
ylabel('Normalized Specific Impulse [s]')

subplot(2,2,3)

plot(NaN,NaN)
hold on
for indexOF = 1:indexPressure
    plot(listOF,listCStarEQ(indexOF,:).*listCFEQ(indexOF,:).*density, 'r-')
    plot(listOF,listCStarFR(indexOF,:).*listCFFR(indexOF,:).*density, 'b-')
end
hold off
xlabel('OF Ratio')
ylabel('Volumetric Specific Impulse [Ns/m^3]')

subplot(2,2,4)
plot(NaN)
hold on
for indexOF = 1:indexPressure
    plot(listOF,listTccEQ(indexOF,:), 'k-')
    plot(listOF,listTccFR(indexOF,:), 'k-')
end
hold off
xlabel('OF Ratio')
ylabel('Flame Temperature [K]')

figure(2)
plot(listOF,density)
title('Average Propellant Density [kg/m^3]')
