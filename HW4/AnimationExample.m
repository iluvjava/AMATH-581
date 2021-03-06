clear variables;
clc;
close all
a = -1;
z = 0:pi/100:2*pi;
y = a*sin(z);
Nz = length(z);

% Set up your plot environment
figure
h = plot(z(1),y(1));
    xlim([z(1) z(end)])  % Fix the frame for the plot. 
ylim([min(y) max(y)])
    xlabel('z')
    ylabel('a*sin(z)')
    legend('my sine function')
    
    init_getframe = struct('cdata',[],'colormap',[]);
    frames = repmat(init_getframe, Nz, 1);
    frames(1) = getframe;
% Get frames
for i = 2:Nz
    set(h,'XData',z(1:i));
    set(h,'YData',y(1:i));
    drawnow;
    frame(i) = getframe;
end
% Play movie
movie(frames)


%%
clear variables;

framer = GetFramer();
f = @(t, x) t*sin(x);
xs = linspace(0, 2*pi, 20);

t = linspace(1, 10, 60);
for J = 1:length(t)
    plot(xs, f(t(J), xs));
    ylim([-10, 10]);
    % drawnow;
    frame(J) = getframe;
end

figure;
movie(frame, 1: length(frame), 60);


%%
% Fluid Animaiton not with FFT
clear variables 

% Setting up Parameters 
n = 64; 
Params = Parameters(n, 20/n);
xs = linspace(-10, 10, n);
ys = linspace(-10, 10, n);  
ys = ys(end:-1:1);
InitialDistribution = @(x, y) exp(-x.^2 - (y.^2./20));
InitialDistribution = @(x, y) InitialDistribution(x - 5, y - 5);
w_vec = VectorizeInitialDistribution(xs, ys, InitialDistribution);
Tspan = 0: 1: 40;
Params.SolveModes = 3; 

% Setting Options for solving and stuff. 

% Solving
ODEFun = @(t, w) Rhs(w, Params);
[Ts, Ws] = ode45(ODEFun, Tspan, w_vec);
DataMatrices = zeros(n, n, size(Ws, 1));
for R = 1: size(Ws, 1)
    DataMatrices(:, :, R) = reshape(Ws(R, :), n, n);
end

Framer = GetFramer();
for I = 1: size(DataMatrices, 3)
    imagesc(DataMatrices(:, :, I));
    disp(strcat("Frame: ", num2str(I/size(DataMatrices, 3))));
    Framer(I) = getframe;
end
%% Play the movie! 
figure; 
% movie(Framer);
WriteFrames(Framer);


%% Fluid but with FFT. 

% Fluid Animaiton 
clear variables 
n = 126; 
Params = Parameters(n, 20/n);
Params.l = 20;
xs = linspace(-10, 10, n);
ys = linspace(-10, 10, n);
ys = ys(end:-1:1);

InitialDistribution = @(x, y) exp(-x.^2 - (y.^2./20));
w_vec = VectorizeInitialDistribution(xs, ys, InitialDistribution);
Tspan = 0: 0.5: 140;
Params.SolveModes = 5; 

OdeOptions = odeset("RelTol", 1e-6, "AbsTol", 1e-6);

% Solving
ODEFun = @(t, w) Rhs(w, Params);
[Ts, Ws] = ode45(ODEFun, Tspan, w_vec, OdeOptions);
DataMatrices = zeros(n, n, size(Ws, 1));
for R = 1: size(Ws, 1)
    DataMatrices(:, :, R) = reshape(Ws(R, :), n, n);
end
%% 
Framer = GetFramer();
for I = 1: size(DataMatrices, 3)
    surf(DataMatrices(:, :, I));
    disp(strcat("Frame: ", num2str(I/size(DataMatrices, 3))));
    Framer(I) = getframe(gcf);
end

%% Play the movie! 
figure; 
% movie(Framer);
WriteFrames(Framer);
%% 
function outArg = WriteFrames(framer)
    vw = VideoWriter('test.avi');
    open(vw);
    for k = 1: length(framer)
       writeVideo(vw, framer(k));
    end
    close(vw);
    
end

