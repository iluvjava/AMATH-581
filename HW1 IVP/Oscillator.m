function Fxnout = Oscillator(t, y, epsilon)
%   Van der Pol Oscillator RHS.

    Fxn1 = @(t, y, epsilon) y(2); 
    Fxn2 = @(t, y, epsilon) epsilon*(1 - y(2)^2)*y(2) - y(1);
    Fxnout = [Fxn1(t, y, epsilon); Fxn2(t, y, epsilon)];

    
    
end
