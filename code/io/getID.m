function ID = getID(nameToFind)
    if nargin > 0
        scoreCutOff = 1.6;
        nameToFind = char(lower(nameToFind));
        possibleSubstances = [];
        fileID = fopen("list.txt");
        line = fgetl(fileID);
        while line > 0
            if line(1) >= '0' && line(1) <= '9'
                strings = split(line);
                name = lower(char(join(strings(2:end-1),' ')));
                if compareCharArr(name,nameToFind) > scoreCutOff
                    possibleSubstances = [possibleSubstances,'  - ',name,newline];
                end
                if string(name) == string(nameToFind)
                    ID = double(string(strings{1}));
                    return
                end
            end
            line = fgetl(fileID);
        end

        if ~isempty(possibleSubstances)            
%             possibleSubstancesString = [];
%             for j = 1:length(possibleSubstances)
%                 possibleSubstancesString = [possibleSubstancesString,sprintf("%s\n",possibleSubstances(j))];
%             end
            error("Requested substance cannot be found, maybe you were searching for:\n%s",possibleSubstances)
        else
            error("Requested substance cannot be found")
        end
    else
        fileID = fopen("list.txt");
        line = fgetl(fileID);
        while line > 0
            disp(line)
            line = fgetl(fileID);
        end
    end
    
    % to calculate possible substances if some typo has been made
    function maxScore = compareCharArr(a,b)
        [m,I] = min([length(a),length(b)]);
        
        maxScore = 0;
        if I == 1
            for i = 1:(length(b) - length(a))+1
                isCharEqual = a == b(i:m+i-1);
                score = 0;
                combo = 0;
                for k = 1:length(isCharEqual)
                    if isCharEqual(k)
                        combo = combo + 1;
                    else
                        combo = 0;
                    end
                    score = score + isCharEqual(k)*combo;
                end
                maxScore = max(maxScore,score);
%                 maxSuperposition = max(sum(isCharEqual),maxSuperposition);
            end
        else
            for i = 1:(length(a) - length(b))+1
                isCharEqual = a(i:m+i-1) == b;
                score = 0;
                combo = 0;
                for k = 1:length(isCharEqual)
                    if isCharEqual(k)
                        combo = combo + 1;
                    else
                        combo = 0;
                    end
                    score = score + isCharEqual(k)*combo;
                end
                maxScore = max(maxScore,score);
%                 maxSuperposition = max(sum(isCharEqual),maxSuperposition);
            end
        end
        maxScore = maxScore/m;
%         fprintf("%s %1.3f\n",a,maxScore)

    end
end