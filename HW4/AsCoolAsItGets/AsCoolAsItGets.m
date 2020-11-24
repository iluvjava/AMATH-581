% This is for HW: As cool as it gets. 
% 1. Benchmark best solver and choose that one for this part of the HW
% 
% Produce Annimations for the following Scienarios
% 1. 2 Oppositely charged Gaussain Vortices next to eahc other. 
% 2. 2 Same chaged Gaussian vortices next to each other. 
% 3. 2 Pairs of oppositely charged vortices which can be made to collided
% with each other. 
% 4. A random assortment of (in position, strenght, charge, ellipticity,
% etc) of vorticces, try 10 - 15 of them. 
% 
% Make then into moview, colors and coolness are the key factor. 


%% Fluid but with FFT. 

% Fluid Animaiton 
clear variables 
n = 256;
L = 20;
DeltaX = L/n;
Params = Parameters(n, DeltaX);
Params.l = 20;
xs = -L/2: DeltaX: L/2 - DeltaX;
ys = xs;
Params.xs = xs; 
Params.ys = ys; 
Tspan = 0: 0.5: 140;
names = {"case1", "case2", "case3"};

for I = [1, 2]
    w_vec = GetInitialDistributions(xs, ys, I);
    SaveToAminations(Params, w_vec, Tspan, n, strcat("Test", num2str(I)));
end


%% 
function outArg = WriteFrames(framer, fileName)
    vw = VideoWriter(fileName);
    open(vw);
    for k = 1: length(framer)
       writeVideo(vw, framer(k));
    end
    close(vw);
    outArg = 1; 
end

function Zs = GetInitialDistributions(xs, ys, modes)
    % Gets the initial distributions, this function will return a function
    % that provides an initial distribution for the simulations. 
    Gaussian = @(a, b, c, d, x, y) exp(-((x - a).^2)./c - ((y - b).^2)./d);
    m = length(ys); n = length(xs);
    xs = meshgrid(xs);
    ys = meshgrid(ys);
    ys = ys';
    switch modes
        case 1
            Zs = - Gaussian(-5, 0, 5, 5, xs, ys) + ...
                   Gaussian(5, 0, 5, 5, xs, ys);
        case 2 
            Zs =   Gaussian(-5, 0, 5, 5, xs, ys) + ...
                   Gaussian(5, 0, 5, 5, xs, ys);
        case 3
            Zs = - Gaussian(-2, 0, 2, 20, xs, ys) + ...
                   Gaussian(2, 0, 2, 20, xs, ys);
        case 4
            error("Not yet implemented");
    end 
    Zs = reshape(Zs, m*n, 1);
end

function argOut = SaveToAminations(params, w_vec, tspan, n, fileName)
    % Run the whole fluid simulations with the given parameters for initial
    % conditions. 

    % w_vec, already passed as parameter. 
    Tspan = tspan;
    params.SolveModes = 5; 
    OdeOptions = odeset("RelTol", 1e-6, "AbsTol", 1e-6);

    % Solving
    ODEFun = @(t, w) Rhs(w, params);
    [~, Ws] = ode45(ODEFun, Tspan, w_vec, OdeOptions);
    DataMatrices = zeros(n, n, size(Ws, 1));

    for R = 1: size(Ws, 1)
        DataMatrices(:, :, R) = reshape(Ws(R, :), n, n);
    end
    %% 
    Framer = GetFramer();
    for I = 1: size(DataMatrices, 3)
        pcolor(params.xs, params.ys, DataMatrices(:, :, I));
        shading interp; colormap("pink"); colorbar;
        disp(strcat("Frame: ", num2str(I/size(DataMatrices, 3))));
        Framer(I) = getframe(gcf);
    end

    %% Play the movie! 
    % figure; 
    % movie(Framer);
    WriteFrames(Framer, fileName);
    argOut = 1;
end

