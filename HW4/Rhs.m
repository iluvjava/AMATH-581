function dwdt = Rhs(w, params)
    % This functions receives the omega, vorticity function, and then it
    % will return the next time-stepping for the vorticity function. 
    % 
    % w: 
    %   Vectorized vorticity function, x, columns, first, and then each of
    %   the sub vectors are the y, rows. 
    % t: Dummy variables, it's just for using the general ODEs solver that
    % is all. 
    % 
    % solveForPsi
    %   A function handle that receives params, and the w to solve for the
    %   stream function. 
    v = 0.001;
    A = params.A; 
    B = params.B; 
    C = params.C; 
    Psi = SolveForPsi(params, w); 
    dwdt = (-B*Psi).*(C*w) + (C*Psi).*(B*Psi) + v.*(A*w);
    
end