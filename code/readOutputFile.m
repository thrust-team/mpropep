function result = readOutputFile(propellantNumber, outputPath, request)
    m = propellantNumber + 5;
    colTitle = 1:18;
    colChamber = 19:31;
    colThroat = 32:44;
    colExit = 45:54;
    
    % Check that output.txt exists
    fid = fopen(['cpropep/', outputPath], 'r');
    if fid == -1
       error('Output file does not exist.');
    end
    
    % Split output file in cells with line content
    scan = textscan(fid,'%s','delimiter','\n');
    
    % Split in column of cells containing strings
    rows = scan{1};
    
    % rows(1) = 'Computing case 1'
    % rows(2) = Solver employed in computation
    % rows(3) = empty
    % rows(4) = 'Propellant composition'
    % rows(5) = 'Code  Name                                mol    Mass (g)  Composition'
    % rows(5+1 to 5+n) = Compounds according to row 5;
    
    % 5+n is now m
    % m+1 = density
    % m+2 = n of elements
    % m+3 = elements
    % m+4 = Total mass
    % m+5 = Enthalpy
    % m+6 = empty
    % m+7 = n of possible gazeous species
    % m+8 = n of possible condensed species
    % m+9 = empty
    % m+10 = 'CHAMBER      THROAT        EXIT'
    % m+11 = Pressure(atm)
    
    switch request
        case 'pressure'
            % Pressure section
            atm = 101325;
            pressureRow = char(rows(m+11));
            pressureChamber = str2double(pressureRow(colChamber))*atm;
            pressureThroat = str2double(pressureRow(colThroat))*atm;
            pressureExit = str2double(pressureRow(colExit))*atm;
        case 'flame'
            % Temperature section
            temperatureRow = char(rows(m+12));
            temperatureChamber = str2double(temperatureRow(colChamber));
            temperatureThroat = str2double(temperatureRow(colThroat));
            temperatureExit = str2double(temperatureRow(colExit));
            result = temperatureChamber;
        case 'specificheatratio'
            % Cp/Cv section
            specificHeatRatioRow = char(rows(m+22));
            specificHeatRatioChamber = str2double(specificHeatRatioRow(colChamber));
            specificHeatRatioThroat = str2double(specificHeatRatioRow(colThroat));
            specificHeatRatioExit = str2double(specificHeatRatioRow(colExit));
        case 'c*'
            % c* section
            characteristicVelocityRow = char(rows(m+28));
            characteristicVelocity = str2double(characteristicVelocityRow(colThroat));
            result = characteristicVelocity;
        case 'cF'
            % cF section
            thrustCoefficientRow = char(rows(m+29));
            thrustCoefficient = str2double(thrustCoefficientRow(colExit));
            result = thrustCoefficient;
        otherwise
            error('Request cannot be satisfied.')
    end
    