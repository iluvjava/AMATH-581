clc; clear variables
import java.util.*;

Gamma1 = 0.05; 
Gamma2 = -0.05;
Tol = 1e-4;
L = 2;

Gammas = [Gamma1, Gamma1, Gamma2, Gamma2];
EpsilonShootingMode = [1, -1, 1, -1];

FoundInitialConditions = ArrayList();
FoundEigenValues = ArrayList();
EigenFunctions = ArrayList();

for I = 1: 4
    A = 2;
    Epsilon = 2; % 1 for even functions, -1 for odd functions
    Gamma = Gammas(I);
    Mode = EpsilonShootingMode(I);
    ForLoopExistCodes = 0;
    for Trials = 1: 200
        % Limit the global movements. 
        DeltaA = 2/Trials^2;
        DeltaEpsilon = 2/Trials^2;
        
        for InitialConditionTrial = 1: 32
            [FxnNorm, ~, ~] = QuantumDoubleShoot(A, Epsilon, Gamma);
            if FxnNorm < 1
                A = A + DeltaA;
            else
                DeltaA = DeltaA/2;
                A = max(A - DeltaA, 0);
            end
            if abs(FxnNorm - 1) < Tol
                disp(strcat("Norm within tolerance: ", num2str(FxnNorm)));
                break
            end
            if DeltaA < 1e-15
                disp(strcat("Delta A shooting failed., A = ", num2str(A)));
                break
            end
        end

        for EpsilonTrials = 1: 32
            [~, Boundary, ~] = QuantumDoubleShoot(A, Epsilon, Gamma);
            if Mode*Boundary > 0
                Epsilon = Epsilon + DeltaEpsilon;
            else
                DeltaEpsilon = DeltaEpsilon/2;
                Epsilon = Epsilon - DeltaEpsilon;
            end
            if abs(Boundary) < Tol
                EpsilonShootingFlag = 1;
                disp("Boundary Value Satisfied: ")
                break;
            end
            if DeltaEpsilon < 1e-15
               disp("Delta epsilon shooting failed. ")
               break; 
            end
        end

        [FxnNorm, Boundary, Solution] = ... 
            QuantumDoubleShoot(A, Epsilon, Gamma);

        if abs(FxnNorm - 1) < Tol && abs(Boundary) < Tol
            FoundEigenValues.add(Epsilon);
            FoundInitialConditions.add(A);
            EigenFunctions.add(abs(Solution));
            disp("a, epsilon shooting process Complete ");
            ForLoopExistCodes = 1;
            break
        end
    end
    if ~ForLoopExistCodes
        error("Failed")
    end
end

A13 = EigenFunctions.get(0);
A14 = EigenFunctions.get(1);
A15 = [FoundEigenValues.get(0); FoundEigenValues.get(1)];

A16 = EigenFunctions.get(2);
A17 = EigenFunctions.get(3);
A18 = [FoundEigenValues.get(2); FoundEigenValues.get(3)];

figure; hold on;

for ToPlot = [A13, A14, A16, A17]
    plot(-L: 0.1: L, ToPlot, "linewidth", 0.5)
end




