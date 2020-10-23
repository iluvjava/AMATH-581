%% Problem 2

L = 4; 
Xs = -L: 0.1: L;
DeltaX = 0.1; 

Band1Band3 = -ones(1, length(Xs) - 3); 
Band2 = 2 + (DeltaX.*Xs(2: end - 1)).^2;

OptMatrix = diag(Band1Band3, - 1) + diag(Band1Band3, 1) + diag(Band2);
OptMatrix = [zeros(1, size(OptMatrix, 1));
             OptMatrix;
             zeros(1, size(OptMatrix, 1))];
