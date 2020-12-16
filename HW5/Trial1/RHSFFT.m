function Argout = RHSFFT(uvvec, params)
    % Given the vector packed with u, v, grids, this function is returning
    % the RHS of the system of ODE, and it will be packaged for the ODEs
    % 45 for evolutions. 
    %
    % uvvec:  The vectorized u, v packed together into one big column vectors. 
    %       FOURIER DOMAIN. 
    % params: An instance of ProblemParameters, containing all the
    %       parameters need to do the computations. 
    
    
    [UFMtx, VFMtx] = params.VectorUnpack(uvvec);
    A2Tdomain      = Asquared(UFMtx, VFMtx);
    
    dudthat = DuDtHat(UFMtx, VFMtx);
    dvdthat = DvDtHat(UFMtx, VFMtx);
    Argout  = params.VectorPack(dudthat, dvdthat);
    
    
    function Argout = DuDtHat(uFMtx, vFMtx) % Foutier domain, Matrix. 
        U      = ifft2(uFMtx);
        V      = ifft2(vFMtx);
        Argout = lambda().*U - omega().*V;
        Argout = fft2(Argout);              % To Fourier. 
        Argout = Argout + params.D1.*Laplacian(uFMtx);
    end

    function Argout = DvDtHat(uFMtx, vFMtx) % Foutier Domain, Matrix. 
        U      = ifft2(uFMtx);
        V      = ifft2(vFMtx);
        Argout = omega().*U + lambda().*V;
        Argout = fft2(Argout);
        Argout = Argout + params.D2.*Laplacian(vFMtx);
    end
    
    function Argout = lambda()         % problem domain out, matrix form
        Argout = 1 - A2Tdomain;
    end

    function Argout = omega()          % problem domain out, matrix form
        Argout = -params.beta.*A2Tdomain;
    end

    function Argout = Laplacian(xfMtx) % problem domain out, matrix form
        Argout = params.Laplacian.*xfMtx;
    end  
end


function Argout = Asquared(uFourier, vFourier) % IN: FOURIER DOMAIN MATRIX FORM 
    
    u = ifft2(uFourier);
    v = ifft2(vFourier);
    
    % Fact: u, v should be mostly reals, because we are under problem
    % domain
    
    Argout = u.^2 + v.^2;
    
end % OUT: TIME DOMAIN MATRIX FORM

