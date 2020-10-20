function Fxnout = Fitzhugh(t, y, params)
%   Fitzhugh neurons system. 
%   params: 
%       This will be an instance of the object "Fizghugh" where it 
%       has all the parameters for the system of ODEs. 
%   Return: 
%       Column vector, the derivative of the function. 

    a1 = params.a1; 
    a2 = params.a2;
    b = params.b;
    c = params.c;
    i = params.i;
    d12 = params.d12;
    d21 = params.d21;
    
    dv1 = @(t, y, a1, a2, b, c, i) ... 
        -y(1)^3 + (1 + a1)*y(1)^2 - a1*y(1) - y(2) + i + d12*y(3);
    
    dw1 = @(t, y, a1, a2, b, c, i) ... 
        b*y(1) - c*y(2);
    
    dv2 = @(t, y, a1, a2, b, c, i) ... 
         -y(3)^3 + (1 + a2)*y(3)^2 - a2*y(3) - y(4) + i + d21*y(1);
    
    dw2 = @(t, y, a1, a2, b, c, i) ... 
        b*y(3) - c*y(4);
       
    Fxnout = [dv1(t, y, a1, a2, b, c, i);
              dw1(t, y, a1, a2, b, c, i); 
              dv2(t, y, a1, a2, b, c, i); 
              dw2(t, y, a1, a2, b, c, i)];
end

