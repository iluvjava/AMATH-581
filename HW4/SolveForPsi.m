function Psi = SolveForPsi(params, w)
    % 
    Psi = 0;
    A2  = params.A2;  % This is the matrix we wanna solve. 
    L = params.L;
    U = params.U; 
    P = params.P;
    switch params.SolveModes
        case 1 % BackSlash
            Psi = A2\w;
            return
        case 2 % LU
            Psi = U\(L\(P*w));
            return
    end
end