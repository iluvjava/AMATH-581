% Homework MATLAB template file
% Your main file should be named "solution.m" and it should be saved as UTF-8 file.

function [consoleout, A1, A2, A3] = solution()
 [consoleout, A1, A2, A3] = evalc('student_solution(0)'); 
end

function [A1, A2, A3] = student_solution(dummy_argument)
    
   % Problem 1
    params      = ProblemParameters(10, 64);
    params.D1   = 0.1;
    params.D2   = 0.1;
    params.m    = 1;
    params.beta = 1;

    [u0, v0]    = params.GetInitialConditionsFFT();

    u0v0Fourier     = params.VectorPack(fft2(u0), fft2(v0));
    tspan           = 0: 0.5: 4;
    [~, solved] = ode45(@(t, y) RHSFFT(y, params), tspan, u0v0Fourier);

    A1 = real(solved);
    A2 = imag(solved);

    % Problem 2
    n           = 30;
    params      = ProblemParameters(10, n);
    params.D1   = 0.1; 
    params.D2   = 0.1; 
    params.m    = 1; 
    params.beta = 1;

    [u0, v0]    = params.GetInitialConditionsCheb();

    u0v0            = [reshape(u0, (params.n + 1)^2, 1); reshape(v0, (params.n + 1)^2, 1)];
    tspan           = 0: 0.5: 4;
    [~, solved] = ode45(@(t, y) RHSCheb(y, params), tspan, u0v0);
    A3 = solved;

end

% your extra functions, if you need them, can be in other files (don't forget to upload them too!)