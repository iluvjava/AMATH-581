% Homework MATLAB template file
% Your main file should be named "solution.m" and it should be saved as UTF-8 file.

function [consoleout, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18] = solution()
 [consoleout, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18] = evalc('student_solution(0)'); 
end

function [A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18] = student_solution(dummy_argument)
    % your solution code goes here
    % assign the variables you are asked to save here 
    [A1, A2, A3, A4, A5, A6] = P1();
    [A7, A8, A9, A10, A11, A12] = P2();
    [A13, A14, A15, A16, A17, A18] = P3();
end
% your extra functions, if you need them, can be in other files (don't forget to upload them too!)

function [A1, A2, A3, A4, A5, A6] = P1(~)
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
        Epsilon = ceil(Epsilon) + 0.2;
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
end

function [A7, A8, A9, A10, A11, A12] = P2(~)
    L = 4; DeltaX = 0.1; Xs = -L + DeltaX: DeltaX: L - DeltaX; 
    XsFull = [-L, Xs, L];

    Band1Band3 = -ones(length(Xs), 1); 
    Band2 = 2 + (DeltaX.*Xs).^2; 
    Band2 = Band2';
    OptMatrix = spdiags... 
        ([Band1Band3, Band2, Band1Band3], -1:1, length(Band2), length(Band2));
    OptMatrix(1, 1:2) = [2/3 + (DeltaX*Xs(1))^2, -2/3];
    OptMatrix(end, end - 1: end) = [-2/3, (DeltaX*Xs(end))^2 + 2/3];
    [V, D] = eigs(OptMatrix, 5, "smallestabs");

    D = D/DeltaX^2;  % Should be this. 

    BSNormAbsEigFxns = ... 
        zeros(size(V, 1)+ 2, size(V, 2));
    % figure; hold on;
    for I = 1: size(V, 2)
        BSNormAbsEigFxns(:, I)...
            = BootStrap(V(:, I), L, D(I, I), DeltaX);
        Fx = BSNormAbsEigFxns(:, I);
        BSNormAbsEigFxns(:, I)... 
            =  abs(Fx./sqrt(trapz(XsFull, (Fx.*Fx))));
        % plot(XsFull, BSNormAbsEigFxns(:, I));
    end
    % Save results for the HW. 

    A7  = BSNormAbsEigFxns(:, 1);
    A8  = BSNormAbsEigFxns(:, 2);
    A9  = BSNormAbsEigFxns(:, 3);
    A10 = BSNormAbsEigFxns(:, 4);
    A11 = BSNormAbsEigFxns(:, 5);
    A12 = diag(D);
end

function [A13, A14, A15, A16, A17, A18] = P3(~)
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
end

