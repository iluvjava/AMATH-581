% Organized the solutions for HW4 and ready to put them into a template for
% submitting. 
% Files Included: 
% 1. This file
% 2. FiniteDiffMatrix
% 3. Parameters.m
%   3.1. PsiGuess
% 4. Rhs.m
% 5. SolveForPsi.m
% 6. VectorizedInitialDistribution.m

clear variables

n = 64; 
AA = zeros(9, 4096, 5);  % To store all solutions.  
xs = linspace(-10, 10, n);
ys = linspace(-10, 10, n); 
ys = ys(end: -1: 1);

Params = Parameters(n, 20/n);
Params.l = 20;  % For fft.
InitialDistribution = @(x, y) exp(-x.^2 - (y.^2./20));
w_vec = VectorizeInitialDistribution(xs, ys, InitialDistribution);

for I = 1: 5
    Tspan = 0: 0.5: 4;
    Params.SolveModes = I; 
    % Setting Options for solving and stuff. 
    
    % Solving
    ODEFun = @(t, w) Rhs(w, Params);
    [Ts, Ws] = ode45(ODEFun, Tspan, w_vec);
    AA(:, :, I) = Ws;
end

A1 = AA(:, :, 1);
A2 = AA(:, :, 2);
A3 = AA(:, :, 3);
A4 = AA(:, :, 4);
A5 = AA(:, :, 5);