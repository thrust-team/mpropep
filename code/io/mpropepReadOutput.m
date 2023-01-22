function outputStruct = mpropepReadOutput(outputPath)
    % da sistemare se un numero è infinito!!!!!!!!!!!!
    if ~exist("outputPath","var")
        outputPath = '.mpropep\output.txt';
    end
    
    % Check that output.txt exists
    fid = fopen(outputPath, 'r');
    if fid == -1
       error('Output file does not exist.');
    end
    
    % Split output file in cells with line content
    scan = textscan(fid,'%s','delimiter','\n');
    
    % Split in column of cells containing strings
    output = scan{1};

    % remove last row (end of file)
    output = output(1:end-1);
    
    % Danger zone
    fclose(fid);

    p_atm = 101325;
    R_univ = 8314.472;
    g0 = 9.81;
    
    switch string(output{2})
        % TP/PT
        case {"Fixed pressure-temperature equilibrium",...
                "Fixed enthalpy-pressure equilibrium - adiabatic flame temperature"}
            rows = [18,19,20,21,22,23,24,27,28,29,30,31];
            fields = ["p","T","h","u","g","s","MM","cp","cv","cp_cv","gamma","a"];
            
            for i = 1:length(rows)
                outputStruct.chamber.(fields(i)) = getNumbers(output{rows(i)});
            end
            outputStruct.chamber.p = outputStruct.chamber.p*p_atm;
          
            molarFractionOffset = 35;
            outputStruct.chamber.species = strings(1,length(output) - molarFractionOffset);
            outputStruct.chamber.n = zeros(1,length(output) - molarFractionOffset);
            
            rmidx = 0;

            for i = 1:length(outputStruct.chamber.n)
                if lower(strtrim(output{i+molarFractionOffset})) == "condensed species"
                    rmidx = i;
                    continue
                end
                stringWithoutMultipleSpaces = removeMultipleWhitespaces(output{i+molarFractionOffset});
                temp = strtrim(split(stringWithoutMultipleSpaces," "));
                outputStruct.chamber.species(i) = string(temp{1});
                outputStruct.chamber.n(i) = str2double(string(temp{2}));
            end
            
            if rmidx > 0
                outputStruct.chamber.species(rmidx) = [];
                outputStruct.chamber.n(rmidx) = [];
            end

            Gamma = outputStruct.chamber.gamma*(2/(outputStruct.chamber.gamma+1))...
                ^((outputStruct.chamber.gamma+1)/(2*(outputStruct.chamber.gamma-1)));

            outputStruct.chamber.cstar = 1/Gamma * ...
                sqrt(outputStruct.chamber.gamma * R_univ/outputStruct.chamber.MM * outputStruct.chamber.T);

        case "Frozen equilibrium performance evaluation"
            rows = [18,19,20,21,22,23,24,27,28,30,31];
            fields = ["p","T","h","u","g","s","MM","cp","cv","gamma","a"];

            for i = 1:length(rows)
                temp = getNumbers(output{rows(i)});
                outputStruct.chamber.(fields(i)) = temp(1);
                outputStruct.throat.(fields(i)) = temp(2);
                outputStruct.exit.(fields(i)) = temp(3);
            end

            rows2 = [33,34,35,39,37];
            fields2 = ["Ae_At","G","cstar","Isp","Ivac"];
            for i = 1:length(rows2)
                temp = getNumbers(output{rows2(i)});
                outputStruct.throat.(fields2(i)) = temp(1);
                outputStruct.exit.(fields2(i)) = temp(2);
            end

            outputStruct.chamber.p = outputStruct.chamber.p*p_atm;
            outputStruct.throat.p = outputStruct.throat.p*p_atm;
            outputStruct.exit.p = outputStruct.exit.p*p_atm;

            outputStruct.throat.G = outputStruct.throat.G/p_atm;
            outputStruct.exit.G = outputStruct.exit.G/p_atm;

            outputStruct.throat.Ivac = outputStruct.throat.Ivac/g0;
            outputStruct.exit.Ivac = outputStruct.exit.Ivac/g0;
                        
            molarFractionOffset = 43;
            outputStruct.chamber.species = strings(1,length(output) - molarFractionOffset);
            outputStruct.chamber.n = zeros(1,length(output) - molarFractionOffset);
            outputStruct.throat.species = outputStruct.chamber.species;
            outputStruct.throat.n = outputStruct.chamber.n;
            outputStruct.exit.species = outputStruct.chamber.species;
            outputStruct.exit.n = outputStruct.chamber.n;
            
            rmidx = 0;

            for i = 1:length(outputStruct.chamber.n)
                if lower(strtrim(output{i+molarFractionOffset})) == "condensed species"
                    rmidx = i;
                    continue
                end
                stringWithoutMultipleSpaces = removeMultipleWhitespaces(output{i+molarFractionOffset});
                temp = strtrim(split(stringWithoutMultipleSpaces," "));
                outputStruct.chamber.species(i) = string(temp{1});
                outputStruct.chamber.n(i) = str2double(string(temp{2}));
                outputStruct.throat.species(i) = string(temp{1});
                outputStruct.throat.n(i) = str2double(string(temp{3}));
                outputStruct.exit.species(i) = string(temp{1});
                outputStruct.exit.n(i) = str2double(string(temp{4}));
            end
            
            if rmidx > 0
                outputStruct.chamber.species(rmidx) = [];
                outputStruct.throat.species(rmidx) = [];
                outputStruct.exit.species(rmidx) = [];

                outputStruct.chamber.n(rmidx) = [];
                outputStruct.throat.n(rmidx) = [];
                outputStruct.exit.n(rmidx) = [];
            end
        otherwise
            error("Problem type not understood")
    end



    function numbers = getNumbers(row)
        outputSplit = removeMultipleWhitespaces(strtrim(split(row,":")));
        numbers = str2double(string(split(outputSplit(2))));
    end

    function str = removeMultipleWhitespaces(str)
         str = regexprep(str,'\s+',' ');
    end
end