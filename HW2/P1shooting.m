%%
clc; 
import java.util.*;

A = 1; L = 4; Epsilon = 1; Xspan = -L: 0.1: L;
Options = odeset("abstol", 1e-13, "reltol", 1e-13);
TOL = 1e-4;  % Higher than given in HW assignment. 

ValidEpsilons = ArrayList();  % Used to stores the valid Epsilons from the shooting method. 
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
           EpsilonStep = EpsilonStep/2;
           Epsilon = Epsilon - EpsilonStep;
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
 	% increase slightly on existing eigen values to search for the next
 	% one. 
    Epsilon = ceil(Epsilon) + round(rand(1,1), 2); 
end

% Extract Eigen values and normalizing the eigen functions. 
Epsilons = zeros(5, 1);
for I = 0: ValidEpsilons.size - 1
    disp(num2str(ValidEpsilons.get(I), '%.8f'));
    Epsilons(I + 1) = ValidEpsilons.get(I);
    EigFx = EigenFunctions.get(I);
    EigFx = abs(EigFx/sqrt(trapz(Xspan, EigFx.*EigFx)));
    EigenFunctions.set(I, EigFx);
    hold on;
    plot(Xspan, EigFx);
end

A1 = EigenFunctions.get(0);
A2 = EigenFunctions.get(1);
A3 = EigenFunctions.get(2);
A4 = EigenFunctions.get(3);
A5 = EigenFunctions.get(4);
A6 = Epsilons;



