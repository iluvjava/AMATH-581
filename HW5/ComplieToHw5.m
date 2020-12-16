% This is the code prepare for the submission of the HW5 onto gradescope.
% file Required: 
% 1. ProblemParameters.m
% 2. FHSFFT.m
% 3. RHSCheb.m
% 4. cheb.m
% 5. <This file>
% PART II

params      = ProblemParameters(10, 64);
params.D1   = 0.1;
params.D2   = 0.1;
params.m    = 1;
params.beta = 1;

[u0, v0]    = params.GetInitialConditionsFFT();
VisualizeProblem(u0, v0);

u0v0Fourier     = params.VectorPack(fft2(u0), fft2(v0));
tspan           = 0: 0.5: 4;
[tspan, solved] = ode45(@(t, y) RHSFFT(y, params), tspan, u0v0Fourier);

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
VisualizeProblem(u0, v0);

u0v0            = [reshape(u0, (params.n + 1)^2, 1); reshape(v0, (params.n + 1)^2, 1)];
tspan           = 0: 0.5: 4;
[tspan, solved] = ode45(@(t, y) RHSCheb(y, params), tspan, u0v0);

A3 = solved;

