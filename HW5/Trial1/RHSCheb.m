function [DudtOverDvdt] = RHSCheb(uv, params)
    % Using the chebyshev matrix to compute the right hand side, and it's
    % Dirichlet boundary conditions.
    
    u      = uv(1: (params.n + 1)^2);       % Vectorized u
    v      = uv((params.n + 1)^2 + 1: end); % Vectorized v
    A2     = u.^2 + v.^2;
    Lambda = 1 - A2;
    Omega  = -params.beta.*A2;
    Laplac = params.chebLaplacian;
    
    Ut = F1(u, v); 
    Vt = F2(u, v); 
    
    DudtOverDvdt = [Ut; Vt];
    
    function Ut = F1(u, v)
        Ut = Lambda.*u - Omega.*v + params.D1.*Laplac*u;
    end

    function Vt = F2(u, v)
        Vt = Omega.*u + Lambda.*v + params.D2.*Laplac*v; 
    end
    
end

