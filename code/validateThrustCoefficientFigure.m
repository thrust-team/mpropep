%% Gasdynamics
% Script to verify as per Shapiro Vol. 1 p. 102 Fig. 4.19

expansionRatios = 10.^linspace(0,3, 1e3);
ambientPressureRatios = ...
    [0 0.001 0.002 0.003 0.005 0.010 0.020 0.030 0.050];

k = 1.2;
pa = 1.0143e5;

set(gca, 'FontName', 'Arial')
semilogx(1,0)
hold on
for pa_p0 = ambientPressureRatios
    f_cf = @(e) getThrustCoefficient(k, e, pa_p0);
    f_cf_conv = @(e) 2*(2/(k+1))^(1/(k-1)) - pa_p0;
    thrustCoefficients = ...
        arrayfun(@(e) f_cf(e)/f_cf_conv(e), expansionRatios);
    semilogx(expansionRatios,thrustCoefficients, 'k');
end
hold off
xlabel('$A_e/A_t$','Interpreter','latex')
ylabel('$\mathcal{I}/\mathcal{I}_{conv.}$','Interpreter','latex')
grid on
axis([1 1e3 0.2 1.8])