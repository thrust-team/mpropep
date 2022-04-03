addpath('gasdynamics')

k = 1.2;

n = 1001;

mv = 10.^linspace(-3,3,n);
av = 10.^linspace(0,10,n);

avf = arrayfun(@(M) getIsentropicAreaRatio(k, M), mv);

mvsub = mv;
mvsup = mv;

for i = 1:length(mv)
    [mvsub(i), mvsup(i)] = ...
    getIsentropicMachFromAreaRatio(...
        k, av(i));
end

%% Figures
% Left is full range
% Right figure is Area Ratio curve in Shapiro 1953, Ch. 4, p. 87, fig. 4.8
figure(1)
subplot(1,2,1)
loglog(1,1)
hold on

% Area ratio law
loglog(mv,avf)

% Test inverse area ratio law
loglog(mvsub,av)
loglog(mvsup,av)

% Lines that approximate graph to give guess
loglog(av.^(-1)*10^(-.25),av, ':g')
loglog(av.^(1/9.5)*10^(.5),av, ':g')

hold off
grid on

axis([1e-11, 1e4, 1e-1, 1e25])

subplot(1,2,2)

loglog(mv,avf)
grid on
axis([0.1, 10, 1e-1, 1e2])