%% Input file creation
% Sample usage:
% writeInputFile([657 1032], [6 1], 'FR_AR', 50e5, 5)

% First argument is a list of propellant ID's. 
% --- listPropellantID: Array of propellant IDs [int]

% Second argument is a list of the quantity to be included in the
% computation. Cpropep supports only grams or moles as a unit.
% The unit used for the mass as argument of the function is the SI kilogram.
% --- listPropellantMass: Array of propellant masses [kg]

% Third argument is the solver type
% There are four possible problems to be solved by cpropep.
% * TP for temperature-pressure fixed problems
% * HP for enthalpy-pressure fixed problems
% * FR for computing the frozen performance
% * EQ for computing the shifting equilibrium performance
% Since exit conditions for FR and EQ may be expressed in two different
% ways, the solver options become six in total. See next comment for
% details.
% Although cpropep can use multiple solvers with a single input.pro file,
% this option is not made use of in mpropep library.
% --- solver: TP, HP, FR_EP, FR_AR, EQ_EP, EQ_AR

% Two additional arguments are left for the different solvers.
% Cpropep accepts 4 pressure units (psi, kPa, atm and bar) and 3
% temperature units (k, c and f). Inputs in the argument must be in SI,
% therefore pressure in pascals [Pa] and temperature in kelvins [K].

% Solver TP
% --- solverArg1: Chamber Pressure [Pa]
% --- solverArg2: Chamber Temperature [K]

% Solver HP
% --- solverArg1: Chamber Pressure [Pa]
% --- solverArg2: gets ignored

% Solver FR_EP and EQ_EP
% --- solverArg1: Chamber Pressure [Pa]
% --- solverArg2: Exit Pressure [Pa]

% Solver FR_AR and EQ_AR
% --- solverArg1: Chamber Pressure [Pa]
% --- solverArg2: Exit Area Ratio [Pa]

function [] = writeInputFile( ...
                                listPropellantID, ...
                                listPropellantMass, ...
                                solver, ...
                                solverArg1, ...
                                solverArg2)
    % Number of components in the simulation
    n = length(listPropellantID);
    
    % Check that components are enough
    if n < 2
        error('Components must be at least two. Insert component twice if alone.')
    end

    % Check that lists are same size
    if length(listPropellantID) ~= length(listPropellantMass)
        error('Number of IDs and masses does not match')
    end
    
    % Check that cpropep.exe is in the right folder
    fileCheck('cpropep/cpropep.exe');

    % Open input file
    inputFile = fopen('cpropep/input.txt','w');
    
    % Premise
    fprintf(inputFile,'### AUTOMATICALLY GENERATED: EDIT AT OWN RISK ###\n');

    % %%%%%%%%%%%%%%%%%%%% Propellant section
    % The input file should first contain a section named 'Propellant' which
    % contains a list of all substances before the reaction. To get a list of
    % the available substances, you can run "cpropep -p" in cmd or you can
    % read the list.txt in cpropep folder.

    fprintf(inputFile,'## Propellant section\nPropellant\n');
    
    % Write a pair of rows for every propellant with comment and compound
    % name
    for i = 1:n
        fprintf(inputFile, '#%s\r\n', getPropellantFromID(listPropellantID(i)));
        fprintf(inputFile, '+%d %1.0f %s\r\n', listPropellantID(i), listPropellantMass(i)*1000, 'g');
    end
    
    % %%%%%%%%%%%%%%%%%%%% Solver section
    % The second part of the input file specifies the solver used in the
    % computation.
    switch solver
        case 'TP'
            fprintf(inputFile,'\n## Fixed temperature pressure condition\n');
            fprintf(inputFile,'TP\n');
            fprintf(inputFile,'+chamber_pressure %f bar \n', solverArg1/1e5); % Pa to bar
            fprintf(inputFile,'+chamber_temperature %f k \n', solverArg2);
        case 'HP'
            fprintf(inputFile,'\n## Fixed enthalpy pressure condition\n');
            fprintf(inputFile,'HP\n');
            fprintf(inputFile,'+chamber_pressure %f bar \n', solverArg1/1e5); % Pa to bar
        case 'FR_EP'
            fprintf(inputFile,'\n## Frozen performance with pressure exit condition\n');
            fprintf(inputFile,'FR\n');
            fprintf(inputFile,'+chamber_pressure %f bar \n', solverArg1/1e5); % Pa to bar
            fprintf(inputFile,'+exit_pressure %f bar \n', solverArg2/1e5); % Pa to bar
        case 'FR_AR'
            fprintf(inputFile,'\n## Frozen performance with area ratio exit condition\n');
            fprintf(inputFile,'FR\n');
            fprintf(inputFile,'+chamber_pressure %f bar \n', solverArg1/1e5); % Pa to bar
            fprintf(inputFile,'+supersonic_area_ratio %f \n', solverArg2);
        case 'EQ_EP'
            fprintf(inputFile,'\n## Shifting equilibrium performance with pressure exit condition\n');
            fprintf(inputFile,'EQ\n');
            fprintf(inputFile,'+chamber_pressure %f bar \n', solverArg1/1e5); % Pa to bar
            fprintf(inputFile,'+exit_pressure %f bar \n', solverArg2/1e5); % Pa to bar
        case 'EQ_AR'
            fprintf(inputFile,'\n## Shifting equilibrium performance with area ratio exit condition\n');
            fprintf(inputFile,'EQ\n');
            fprintf(inputFile,'+chamber_pressure %f bar \n', solverArg1/1e5); % Pa to bar
            fprintf(inputFile,'+supersonic_area_ratio %f \n', solverArg2);
        otherwise
            error('Solver type not found. Available solvers are TP, HP, FR_EP, FR_AR, EQ_EP, EQ_AR.');
    end
    
    % Close input file
    fclose(inputFile);
end