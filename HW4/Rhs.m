function dwdt = Rhs(w, params)
    % This functions receives the omega, vorticity function, and then it
    % will return the next time-stepping for the vorticity function. 
    % 
    % w: 
    %   Vectorized vorticity function, x, columns, first, and then each of
    %   the sub vectors are the y, rows. 
    % params: 
    %   An instance of the Parameters class, so the function can take
    %   whatever parameters it needs from the class properties and apply
    %   then. 
    v = 0.001;
    A = params.A;
    B = params.B;
    C = params.C;
    Psi = SolveForPsi(params, w);
    dwdt = -(B*Psi).*(C*w) + (C*Psi).*(B*w) + v.*(A*w);
end