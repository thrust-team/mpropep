clc
clear
close all

addpath("cpropep")
addpath("io")
addpath("gasdynamics")
addpath("num")

fuelID = getID("methane");
oxID = getID("oxygen (gas)");

O_F_vec = linspace(1,10,20);

p_cc = 10e5;
p_e = 1e5;
propellantList = [fuelID,oxID];

T = O_F_vec*0;
cstar = T;
n = cell(1,length(O_F_vec));
species = cell(1,length(O_F_vec));

for i = 1:length(O_F_vec)
    fprintf("completion: %1.1f%%\n",100 * (i-1)/(length(O_F_vec)-1))
    mpropepWriteInput(propellantList, [1,O_F_vec(i)], 'HP',p_cc, p_e)
    mpropepRun();
    output = mpropepReadOutput();
    T(i) = output.chamber.T;
    cstar(i) = output.chamber.cstar;
    n{i} = output.chamber.n;
    species{i} = output.chamber.species;
end

%%
close all
figure
hold on
yyaxis left
plot(O_F_vec,T)
ylabel("T [K]")

yyaxis right
plot(O_F_vec,cstar)
ylabel("cstar [m/s]")

title("Performances vs O/F")
xlabel("O/F")
box on
grid on

legend("T","c*",'location','best')



species_tot = strings(1,0);
for i = 1:length(species)
    species_tot = union(species_tot,species{i});
end

n_tot = zeros(length(O_F_vec),length(species_tot));

for i = 1:length(O_F_vec)
    for j = 1:length(species{i})
        idx_tot = species{i}(j) == species_tot;
        idx = species{i} == species_tot(idx_tot);
        n_tot(i,idx_tot) = n{i}(idx);
    end
end

figure
hold on

plotIdx = [];

markers = ["o","s","p","d"];

for i = 1:length(species_tot)
    if any(n_tot(:,i) > 1e-5)
        plot(O_F_vec,n_tot(:,i),markers(1+mod(i-1,length(markers)))+"-",'markersize',4)
        plotIdx = [plotIdx,i];
    end
end

legend(species_tot(plotIdx),"location","eastoutside")
box on
grid on
