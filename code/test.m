clear all
    
listPropellantID = [657 1032];
propellantNumber = length(listPropellantID);

inputPath = 'input.txt';
outputPath = 'output.txt';

oxidizerDensity = 688; % kg/m3 liquid phase at 25C
fuelDensity = 900; % kg/m3

expansionRatio = 5;

g = 9.80665;

listOF = linspace(2, 16, 20);
listPressure = linspace(20e5, 50e5, 5);
n = length(listOF);
listCStarEQ = zeros(1, n);
listCStarFR = zeros(1, n);
listCFEQ = zeros(1, n);
listCFFR = zeros(1, n);

%% Compute average density
density = fuelDensity * 1 ./ ( 1 + listOF ) + oxidizerDensity .* listOF ./ ( 1 + listOF );

%% Computation section
j = 1;
for pressure = listPressure
    i = 1;
    for OF = listOF
        listMass = [OF 1]*1e-3;

        writeInputFile(listPropellantID, listMass, 'EQ_AR', pressure, expansionRatio)
        runComputation(inputPath, outputPath);
        output = readOutputFile(outputPath);

        listCStarEQ(j,i) = getParamFromOutput(propellantNumber, 'c*', 'EQ_AR', output);
        listCFEQ(j,i) = getParamFromOutput(propellantNumber, 'cF', 'EQ_AR', output);

        writeInputFile(listPropellantID, listMass, 'FR_AR', pressure, expansionRatio)
        runComputation(inputPath, outputPath);
        output = readOutputFile(outputPath);

        listCStarFR(j,i) = getParamFromOutput(propellantNumber, 'c*', 'FR_AR', output);
        listCFFR(j,i) = getParamFromOutput(propellantNumber, 'cF', 'FR_AR', output);
        i = i + 1;
    end
    j = j + 1;
end
j = j - 1;

%% Plotting section
subplot(2,2,1)
plot(listOF,listCStarEQ(1,:), 'r-')
plot(listOF,listCStarFR(1,:), 'b-')
hold on
for i = 2:j
plot(listOF,listCStarEQ(i,:), 'r-')
plot(listOF,listCStarFR(i,:), 'b-')
end
hold off
axis([listOF(1) listOF(end) min(listCStarEQ(1,:))/2 max(listCStarEQ(1,:))*1.5])
title('Characteristic Velocity [m/s]')
legend('Shifting Eq.','Frozen')

subplot(2,2,2)
plot(listOF,listCStarEQ(1,:).*listCFEQ(1,:)/g, 'r-')
plot(listOF,listCStarFR(1,:).*listCFFR(1,:)/g, 'b-')
hold on
for i = 2:j
plot(listOF,listCStarEQ(i,:).*listCFEQ(i,:)/g, 'r-')
plot(listOF,listCStarFR(i,:).*listCFFR(i,:)/g, 'b-')
end
hold off
axis([listOF(1) listOF(end) 100 250])
title('Normalized Specific Impulse [s]')
legend('Shifting Eq.','Frozen')

subplot(2,2,3)
plot(listOF,density)
title('Average Propellant Density [kg/m^3]')

subplot(2,2,4)
plot(listOF,listCStarEQ(1,:).*listCFEQ(1,:).*density, 'r-')
plot(listOF,listCStarFR(1,:).*listCFFR(1,:).*density, 'b-')
hold on
for i = 2:j
plot(listOF,listCStarEQ(i,:).*listCFEQ(i,:).*density, 'r-')
plot(listOF,listCStarFR(i,:).*listCFFR(i,:).*density, 'b-')
end
hold off
title('Volumetric Specific Impulse [Ns/m^3]')
legend('Shifting Eq.','Frozen')
