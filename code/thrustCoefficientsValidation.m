expansionRatios = 10.^linspace(0,3, 1e3);
ambientPressureRatios = [0 0.001 0.002 0.003 0.005 0.010 0.020 0.030 0.050];
k = 1.2;

machs = arrayfun(@(e) getMachFromAreaRatio(1.2, e, 1e2),expansionRatios);
exitPressureRatios = arrayfun(@(M) getIsentropicPressureRatio( k , M ),machs);


for pa_p0 = ambientPressureRatios
    thrustCoefficients = arrayfun(@(e) getThrustCoefficient(k, e, pa_p0),expansionRatios);
    semilogx(expansionRatios,thrustCoefficients, 'k');
    hold on
end
hold off
grid on
axis([1 1e3 0 2])