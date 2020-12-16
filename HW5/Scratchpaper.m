% Testing if the Porblem Parameters Class is working correctly. 
clear variables; clc;
params      = ProblemParameters(10, 64);
params.D1   = 0.5;
params.D2   = 0.5;
params.m    = 1;
params.beta = 1;

[u0, v0]    = params.GetInitialConditionsFFT();
VisualizeProblem(u0, v0);

u0v0Fourier     = params.VectorPack(fft2(u0), fft2(v0));
tspan           = 0: 0.5: 90;
[tspan, solved] = ode45(@(t, y) RHSFFT(y, params), tspan, u0v0Fourier);

%% PLOTTING.
Framer = GetFramer();
for II = 1: size(solved, 1)
    [uf, vf] = params.VectorUnpack(solved(II, :));
    ut       = ifft2(uf);
    vt       = ifft2(vf);
    VisualizeProblem(ut, vt);
    disp(strcat("Frame: ", num2str(II)));
    Framer(II) = getframe(gcf);
end
WriteFrames(Framer, "SimFFT");




