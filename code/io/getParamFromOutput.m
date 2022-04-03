function result = getParamFromOutput(propellantNumber, request, solver, output)
    m = propellantNumber + 5;
    
%     colTitle = 1:18;
    colChamber = 19:31;
    colThroat = 32:44;
    colExit = 45:54;
    
    % rows(1) = 'Computing case 1'
    % rows(2) = Solver FR or EQ
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
            pressureRow = char(output(m+11));
            pressureChamber = str2double(pressureRow(colChamber))*atm;
            pressureThroat = str2double(pressureRow(colThroat))*atm;
            pressureExit = str2double(pressureRow(colExit))*atm;
        case 'flame'
            % Temperature section
            temperatureRow = char(output(m+12));
            temperatureChamber = str2double(temperatureRow(colChamber));
            temperatureThroat = str2double(temperatureRow(colThroat));
            temperatureExit = str2double(temperatureRow(colExit));
            result = temperatureChamber;
        case 'specificheatratio'
            % Cp/Cv section
            specificHeatRatioRow = char(output(m+22));
            specificHeatRatioChamber = str2double(specificHeatRatioRow(colChamber));
            specificHeatRatioThroat = str2double(specificHeatRatioRow(colThroat));
            specificHeatRatioExit = str2double(specificHeatRatioRow(colExit));
        case 'c*'
            % c* section
            characteristicVelocityRow = char(output(m+28));
            characteristicVelocity = str2double(characteristicVelocityRow(colThroat));
            result = characteristicVelocity;
        case 'cF'
            % cF section
            thrustCoefficientRow = char(output(m+29));
            thrustCoefficient = str2double(thrustCoefficientRow(colExit));
            result = thrustCoefficient;
        otherwise
            error('Request cannot be satisfied.')
    end
end