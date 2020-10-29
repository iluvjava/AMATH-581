function [FxnNorm, Boundary, Solution] = ...
    QuantumDoubleShoot(a, epsilon, gamma)
    % Given a set of parameters to shoot for the boundary values on the
    % other side. 
    L = 2; 
    y0 = [a, a*sqrt(L^2 - epsilon)];
    Xspan = -L: 0.1: L;
    [~, Ys] = ode45(@NonLinearQuantum, Xspan, y0);
    Phi = Ys(:, 1);
    FxnNorm = sqrt(trapz(Xspan, abs(Phi.*Phi)));
    Boundary = Ys(end, 2) + sqrt(L^2 - epsilon)*Ys(end, 1);
    Solution = Phi;
    
    function Y = NonLinearQuantum(x, y)
        y1 = @(x, y) y(2);
        y2 = @(x, y) (gamma*abs(y(1)) + x^2 - epsilon)*y(1);
        Y  = [y1(x, y); y2(x, y)];
    end
end