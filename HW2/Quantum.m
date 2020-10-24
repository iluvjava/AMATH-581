function Fxnout = Quantum(t, x, epsilon)
    % The linear version of the quantum density function. 
    dy1 = @(t, y, epsilon) y(2); 
    dy2 = @(t, y, epsilon) (t^2 - epsilon)*y(1);
    Fxnout = [dy1(t, x, epsilon); dy2(t, x, epsilon)];
end

