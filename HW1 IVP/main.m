
clear all; close all, clc;

% Setting things up. 

%% 
% Order of accuracy for the Euler, Heun's methods:
hold on;

DeltaTs = 2.^(-2:-1:-8); 
Errors = zeros(1, length(DeltaTs));
Analytical = @(t) pi*exp(3*(cos(t) - 1))/sqrt(2);
f = @(t, y) -3*y*sin(t); y0 = pi/sqrt(2);
Ans = {};
for H = {@ForwardEuler, @HeunMethod}
    for I = 1:length(DeltaTs)
        TimeSeries = 0: DeltaTs(I): 5;
        YsAnalytical = Analytical(TimeSeries);
        YsNumerical = H{1}(f, y0, TimeSeries);
        Errors(I) = mean(abs(YsAnalytical - YsNumerical));
    end
    PolyFit = polyfit(log(DeltaTs), log(Errors), 1);
    plot(log(DeltaTs), log(Errors), "o-");
    title("Local Error Magnitude");
    ylabel("log(E)"); xlabel("log(\Delta t)");
    Ans{end + 1} = YsNumerical.';
    Ans{end + 1} = Errors;
    Ans{end + 1} = PolyFit(1);
end
legend("ForwardEuler", "HeunMethod", "location", "best");

% Stores the answers for the questions
A1 = Ans{1}; A2 = Ans{2}; A3 = Ans{3}; A4 = Ans{4};
A5 = Ans{5}; A6 = Ans{6};


%% ------------------------------------------------------------------------
% The Vander Pol Osicllator

Tspan = 0: 0.5: 32;
Epsilons = [0.1, 1, 20];
y0 = [sqrt(3), 1];
import java.util.*; P2Answers1 = ArrayList(); % Trouble -------------------

% figure; hold on;

for Epsilon = Epsilons
    [Tout, Yout] = ode45(@(t, y) Oscillator(t, y, Epsilon), Tspan, y0);
    % plot(Yout(:, 1), Yout(: ,2));
    P2Answers1.add(Yout(:, 1));
end
A7 = [P2Answers1.get(0) P2Answers1.get(1)  P2Answers1.get(2)]; 

%% ------------------------------------------------------------------------
% No specifying the step size, but specified the Tolerance. 

Slopes = [];

for OdeSolver = {@ode45, @ode23, @ode113}

    Tspan = [0, 32];
    Epsilon = 1; y0 = [2, pi*pi];
    TOLs = 10.^[-(4:1:10)];
    import java.util.*; Arr = ArrayList();  % Trouble ---------------------

    for TOL = TOLs
       Options = odeset("AbsTol", TOL, "RelTol", TOL);
       [T, Y] = OdeSolver{1}...
           (@(t, y) Oscillator(t, y, Epsilon), Tspan, y0, Options);
       AvgDiff = mean(diff(T));
       % figure;
       % plot(Y(:, 1), Y(:, 2));
       disp(strcat("For a Tol of ", num2str(TOL),... 
           " the mean time stepping diff is "... 
           , num2str(AvgDiff)));
       Arr.add(mean(diff(T)));
    end

    P2Answers2 = zeros(1, Arr.size);
    for I = 1: Arr.size
        P2Answers2(I) = Arr.get(I - 1);
    end

    % ---------------------------------------------------------------------
    loglog(P2Answers2, TOLs, "o-"); hold on;
    xlabel("$\log(\Delta t)$", 'interpreter', 'latex');
    ylabel("log(TOL)");

    % ---------------------------------------------------------------------
    % Get the slope out of the log log plot. 
    Coefficients = polyfit(log(P2Answers2), log(TOLs), 1);
    Slopes(end + 1) = Coefficients(1);
    disp(strcat("The Slope is: ", num2str(Slope)));

end
A8 = Slopes(1); A9 = Slopes(2); A10 = Slopes(3);
legend("45", "23", "113");

%% Probem 3: 
% Fitzhugh Neurons ODEs 
