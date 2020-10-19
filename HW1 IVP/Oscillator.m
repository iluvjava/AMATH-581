function Fxnout = Oscillator(t, y, epsilon)
%   Van der Pol Oscillator RHS.

    Fxnout = [Fxn1(t, y, epsilon); Fxn2(t, y, epsilon)];

    function Fxnout = Fxn1(t, y, epsilon)
        Fxnout = y(2);
    end

    function Fxnout = Fxn2(t, y, epsilon)
        Fxnout = epsilon*(1 - y(2)^2)*y(2) - y(1);
    end

end
