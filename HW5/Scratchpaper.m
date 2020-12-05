% Testing if the Porblem Parameters Class is working correctly. 
clear variables; clc;
params      = ProblemParameters(10, 128);
params.D1   = 0.1; 
params.D2   = 0.1; 
params.m    = 1; 
params.beta = 1;

[u0, v0] = params.GetInitialConditions();
VisualizeProblem(u0, v0);

u0v0  = params.VectorPack(fft2(u0), fft2(v0));
tspan = 0: 0.1: 10;
[tspan, solved] = ode45(@(t, y) RHSFFT(y, params), tspan, u0v0);

%% PLOTTING
figure('Renderer', 'painters', 'Position', [0 0 400 900]);
for II = 1: size(solved, 1)
    [uf, vf] = params.VectorUnpack(solved(II, :));
    ut       = ifft2(uf);
    vt       = ifft2(vf);
    VisualizeProblem(ut, vt);
    pause(0.5);
end

 %% HELPER FUNCTIONS. 
function null = VisualizeProblem(u, v)

    subplot(2, 1, 1);
    
    pcolor(u); shading interp; title("U_t")
    grid on
    pbaspect([1 1 1]);
    
    subplot(2, 1, 2);
    pcolor(v); shading interp; title("V_t")
    grid on
    pbaspect([1 1 1]);
    
    null = nan;
end