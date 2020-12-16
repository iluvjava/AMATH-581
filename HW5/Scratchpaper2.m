% Testing if the Porblem Parameters Class is working correctly. 
clear variables; clc;
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


%% PLOTTING.
Framer = GetFramer();
for II = 1: size(solved, 1)
    % [ut, vt] = params.VectorUnpack(solved(II, :)); 
    ut         = reshape(solved(II, 1: (n + 1)^2), (n + 1), (n + 1));
    vt         = reshape(solved(II, (n + 1)^2 + 1: end), (n + 1), (n + 1));
    VisualizeProblem(ut, vt, params.ChebXGrids, params.ChebYGrids);
    disp(strcat("Frame: ", num2str(II)));
    Framer(II) = getframe(gcf);
end
WriteFrames(Framer, "SimCheb");




