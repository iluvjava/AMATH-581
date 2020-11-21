% Homework MATLAB template file
% Your main file should be named "solution.m" and it should be saved as UTF-8 file.

function [consoleout, A1, A2, A3, A4, A5] = solution()
    [consoleout, A1, A2, A3, A4, A5] = evalc('student_solution(0)'); 
end

function [A1, A2, A3, A4, A5] = student_solution(dummy_argument)
    
    n = 64; 
    AA = zeros(9, 4096, 5);  % To store all solutions.  
    xs = linspace(-10, 10, n);
    ys = linspace(-10, 10, n); 

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
end

% your extra functions, if you need them, can be in other files (don't forget to upload them too!)