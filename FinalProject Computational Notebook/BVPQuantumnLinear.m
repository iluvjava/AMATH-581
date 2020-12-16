import java.util.*;
A = 0.1; L = 4; Epsilon = 1; Xspan = -L: 0.1: L;
Options = odeset("abstol", 1e-13, "reltol", 1e-13);
TOL = 1e-4;                    % Higher than given in HW assignment. 

ValidEpsilons = ArrayList();   % Used to stores the valid Epsilons from the shooting method. 
EigenFunctions = ArrayList();  % Used to stores the corresponding, normalized eigen functions. 

for ModeTrial = 1:5
    EpsilonStep = 2;  % Maximal Distance can move is 2, if oscilates, then it's 1.
    OddSearch = (-1)^(ModeTrial - 1);  % search mode, 1: even functions, -1: odd function
    SearchFlag = 0;  % Search Failed. 
    y0 = [A, A*sqrt(L^2 - Epsilon)];

    while 1
        [Xs, Ys] = ode45(@(t, y) Quantum(t, y, Epsilon), Xspan, y0);
        Shoot = Ys(end, 2) + sqrt(L^2 - Epsilon)*Ys(end, 1);
        % Found. 
        if abs(Shoot) < TOL
            SearchFlag = 1;
            break
        end
        % Failed. 
        if EpsilonStep < 1e-15
           break 
        end
        % Try again. 
        if Shoot*OddSearch > 0
           Epsilon = Epsilon + EpsilonStep;
        else
           Epsilon = Epsilon - EpsilonStep;
           EpsilonStep = EpsilonStep/2;
        end

    end

    if SearchFlag
        disp(strcat("escaped with BV: ", num2str(Shoot)));
        disp(strcat("escaped with epsilon of: ", num2str(Epsilon)));
        ValidEpsilons.add(Epsilon); 
        EigenFunctions.add(Ys(:, 1));
    else
        disp("Search Failed.");
    end
    % increase it by 2 because I know the final answer will be close to
    % this
    Epsilon = ceil(Epsilon) + 2;
end

% Extract Eigen values and normalizing the eigen functions. 
Epsilons = zeros(5, 1);
for I = 0: ValidEpsilons.size - 1
    disp(num2str(ValidEpsilons.get(I), '%.8f'));
    Epsilons(I + 1) = ValidEpsilons.get(I);
    EigFx = EigenFunctions.get(I);
    % plot(Xspan, EigFx); hold on;
    EigFx = abs(EigFx/sqrt(trapz(Xspan, EigFx.*EigFx)));
    EigenFunctions.set(I, EigFx);
end

A1 = EigenFunctions.get(0);
A2 = EigenFunctions.get(1);
A3 = EigenFunctions.get(2);
A4 = EigenFunctions.get(3);
A5 = EigenFunctions.get(4);
A6 = Epsilons;

for ToPlot = [A1, A2, A3, A4, A5]
   plot(Xspan, ToPlot); hold on; 
end
title("Smallse Five Modes normalized"); 
saveas(gcf, "smallest-5-modes-normalized", "png");
    
function Fxnout = Quantum(t, x, epsilon)
    % The linear version of the quantum density function. 
    dy1 = @(t, y, epsilon) y(2); 
    dy2 = @(t, y, epsilon) (t^2 - epsilon)*y(1);
    Fxnout = [dy1(t, x, epsilon); dy2(t, x, epsilon)];
end

