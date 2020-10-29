function Diff = RHSDV(epsilons)
    Diff = zeros(size(epsilons)); 
    Options = odeset("abstol", 1e-8, "reltol", 1e-8);
    for I = 1: length(epsilons)
        epsilon = epsilons(I);
        A = 1; L = 4;
        y0 = [A, A*sqrt(L^2 - epsilon)];
        Tspan = -L: 0.1: L;
        [Xs, Ys] = ode45(@(t, y) Quantum(t, y, epsilon), Tspan, y0);
        Diff(I) = Ys(end, 2) + sqrt(L^2 - epsilon)*Ys(end, 1);
    end
end