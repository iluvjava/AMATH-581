% This is for HW: As cool as it gets. 
% 1. Benchmark best solver and choose that one for this part of the HW
% 
% Produce Annimations for the following Scienarios
% 1. 2 Oppositely charged Gaussain Vortices next to eahc other. 
% 2. 2 Same chaged Gaussian vortices next to each other. 
% 3. 2 Paris of oppositely charged vortices which can be made to collided
% with each other. 
% 4. A random assortment of (in position, strenght, charge, ellipticity,
% etc) of vorticces, try 10 - 15 of them. 
% 
% Make then into moview, colors and coolness are the key factor. 


%% Fluid but with FFT. 

% Fluid Animaiton 
clear variables 

n = 1024; 
L = 20;
DeltaX = L/n;
Params = Parameters(n, DeltaX);
Params.l = 20;
xs = -L/2: DeltaX: L/2 - DeltaX;
ys = xs;

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
    pcolor(xs, ys, DataMatrices(:, :, I));
    shading interp; colormap("pink"); colorbar;
    disp(strcat("Frame: ", num2str(I/size(DataMatrices, 3))));
    Framer(I) = getframe(gcf);
end

%% Play the movie! 
% figure; 
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

function f = GetInitialDistributions(modes)
    % Gets the initial distributions, this function will return a function
    % that provides an initial distribution for the simulations. 
    
    switch modes
        case 1
            return 
        case 2 
            return
        case 3
            return
        case 4
            return
    end
    f = 0;
end

function argOut = SaveToAminations(datMatrix, fileName)
    % This function will accept the data matrix from the simulations and
    % then return save an animations. 
    
    
    
    argOut; 
end

