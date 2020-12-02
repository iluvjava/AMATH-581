function Argout = RHS(uvvec, params)
    % Given the vector packed with u, v, grids, this function is returning
    % the RHS of the system of ODE, and it will be packaged for the ODEs
    % 45 for evolutions. 
    %   uvvec: The vectorized u, v packed together into one big column vectors. 
    %   params: An instance of ProblemParameters, containing all the
    %   parameters need to do the computations. 
    
    
end


function Argout = Asquared(uFourier, vFourier)
    % Compute the A^2 quantity as specified in the HW5, and takes in u, v,
    % the reactions agents under the fourier domain for computations. 
    
    u = ifft2(uFourier); 
    v = ifft2(vFourier); 
    
    % Fact: u, v should be mostly reals, because we are under problem
    % domain
    
    Argout = (u.^2 + v.^2).^2;
    Argout = fft2(Argout);  % Back to fourier domain. 
    
end

