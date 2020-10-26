%% Problem 2

L = 20; 
DeltaX = 0.01; 
Xs = -L: DeltaX: L;

Band1Band3 = -ones(1, length(Xs) - 1); 
Band2 = 2 + (DeltaX.*Xs).^2;

% OptMatrix = spdiags(Band1Band3, - 1, 81, 81) + spdiags(Band1Band3, 1, 81, 81) + spdiags(Band2);
OptMatrix = spdiags([Band1Band3, Band2, Band1Band3], -1:1, 81, 81);
% OptMatrix(1, 1:3) = [0, -2/3, 2/3];
OptMatrix(1, 1:3) = ([-3, 4, -1]/2)*DeltaX^2;
% OptMatrix(1, end - 2: end) = [2/3, -2/3, 0];
OptMatrix(1, end - 2: end) = ([1, -4, 3]/2)*DeltaX^2;
OptMatrix = OptMatrix./DeltaX

[V, D] = eigs(OptMatrix, 5, "smallestabs");
hold on;
for Col = V
    plot(Xs, abs(Col));
end

% Refine the boundary values: 
ForloopCount = 1;
for Col = V
    
end

%% Problem 2 A very good Computation Restults: 
clear variables; 
L = 8;
DeltaX = 0.001; 
Xs = -L: DeltaX: L;

Band1Band3 = -ones(length(Xs), 1); 
Band2 = 2 + (DeltaX.*Xs).^2; 
Band2 = Band2';
OptMatrix = spdiags... 
    ([Band1Band3, Band2, Band1Band3], -1:1, length(Band2), length(Band2));
OptMatrix(1, 1:3) = [-3, 4, -1]/(2*DeltaX);
OptMatrix(end, end - 2: end) = [1, -4, 3]/(2*DeltaX);

[V, D] = eigs(OptMatrix, 5, "smallestabs");
disp(D/DeltaX^2);
hold on;
for Col = V
    plot(Xs, abs(Col));
end



%% Problem 2 BootStrap 
clear variables; 
L = 4; 
DeltaX = 0.1; 
Xs = -L: DeltaX: L;

Band1Band3 = -ones(length(Xs), 1); 
Band2 = 2 + (DeltaX.*Xs).^2; 
Band2 = Band2';
OptMatrix = spdiags... 
    ([Band1Band3, Band2, Band1Band3], -1:1, length(Band2), length(Band2));
OptMatrix(1, 1:3) = [1, -2 + DeltaX*Xs(1)^2, 1];
OptMatrix(end, end - 2: end) = [1, -2 + DeltaX*Xs(end)^2, 1];
% OptMatrix(end, end - 2: end) = [1, -4, 3]/(2*DeltaX);

[V, D] = eigs(OptMatrix, 5, "smallestabs");
D = D/DeltaX^2;  % Should be this. 
hold on;
for Col = V
    plot(Xs, abs(Col));
end

%% Problem 2 everuything follows from the PPT. 
clear variables
L = 4; DeltaX = 0.1; Xs = -L: DeltaX: L;

Band1Band3 = -ones(length(Xs), 1); 
Band2 = 2 + (DeltaX.*Xs).^2; 
Band2 = Band2';
OptMatrix = spdiags... 
    ([Band1Band3, Band2, Band1Band3], -1:1, length(Band2), length(Band2));
OptMatrix(1, 1:2) = [2/3 + (DeltaX*Xs(1))^2, -2/3];
OptMatrix(end, end - 1: end) = [-2/3, (DeltaX*Xs(end))^2 + 2/3];
[V, D] = eigs(OptMatrix, 5, "smallestabs");
D = D/DeltaX^2;  % Should be this. 
figure; hold on;
for Col = V
    plot(Xs, abs(Col));
end
title("No Bootstrap");

Counter = 1; 
figure; hold on;
for Col = V
    plot(Xs, abs(BootStrap(Col, L, D(Counter, Counter), DeltaX)))
    Counter = Counter + 1;
end
title("Bootstrap with BC ");

% Bootstrap the boundary
function Res = BootStrap(solutionVec, L, Epsilon, DeltaX)
    Res = solutionVec;
    Res(1) = (4*Res(2) - Res(3))/(1/(2*DeltaX) + sqrt(L^2 - Epsilon));
    Res(end) = (4*Res(end - 1)... 
        - Res(end - 2))/(1/(2*DeltaX) + sqrt(L^2 - Epsilon));
end

