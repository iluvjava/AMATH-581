classdef ProblemParameters
    % This class is going to contain all the parameters needed for the
    % reaction diffusion problem. 
    % 
    % This class should not stored everything that is directed used during
    % simulations that is slow and it's not the purpose of this class.
    
    properties
        % Grid set up
        L;         % x, y \in [-L, L];
        n;         % Number of grid discritizations;
        Deltax;
        
        % System parameters: 
        D1; D2; m; beta;
        
        % Intermediate parameters for problem solving. 
        xs; ys;
        kx; ky;       % vecotrs; For FFT, NON PERTUBATED.
        Kx; Ky;       % Matrices; For FFT
        Laplacian;    % Matrix, for FFT 
        
        chebX; chebD2; % For chebyshev
        chebLaplacian; 
        ChebXGrids; 
        ChebYGrids; 

    end
    
    methods
        function this = ProblemParameters(L, n)
            this.L      = L;
            this.n      = n;
            this.Deltax = (2*L)/n;
            
            this.xs     = -L: this.Deltax: L - this.Deltax;
            this.ys     = this.xs;
            
            this.kx     = 1i.*fftshift((pi/L).*(-n/2: n/2 - 1));
            this.ky     = this.kx;
            
            [this.Kx, this.Ky] = meshgrid(this.kx, this.ky);
            this.Laplacian     = this.Kx.^2 + this.Ky.^2;
            
            [D, this.chebX]           = cheb(n);
            this.chebD2               = D^2; 
            this.chebD2(1, :)         = 0; 
            this.chebD2(end, :)       = 0;

            I                        = eye(n + 1);
            this.chebLaplacian       = kron(this.chebD2, I) ...
                                     + kron(I, this.chebD2);
            % Domain remap
            this.chebLaplacian       = this.chebLaplacian.*(1/L^2);
            
            [this.ChebXGrids, this. ChebYGrids]...
            = meshgrid(this.chebX, this.chebX);
        
            this.ChebXGrids = L.*this.ChebXGrids; 
            this.ChebYGrids = L.*this.ChebYGrids; 
            
        end

        % Problem domain, Matrix form, for FFT. 
        function [u, v] = GetInitialConditionsFFT(this) 
           [X, Y] = meshgrid(this.xs, this.ys);
           m      = 1;  % Number of Spirals.
           u      = tanh(sqrt(X.^2 + Y.^2)).*... 
               cos(m*angle(X + 1i*Y) - (sqrt(X.^2 + Y.^2)));
           v      = tanh(sqrt(X.^2 + Y.^2)).*... 
               sin(m*angle(X + 1i*Y) - (sqrt(X.^2 + Y.^2)));
        end
        
        function [u, v] = GetInitialConditionsCheb(this) 
           X      = this.ChebXGrids; 
           Y      = this.ChebYGrids;
           m      = 1;  % Number of Spirals.
           u      = tanh(sqrt(X.^2 + Y.^2)).*... 
               cos(m*angle(X + 1i*Y) - (sqrt(X.^2 + Y.^2)));
           v      = tanh(sqrt(X.^2 + Y.^2)).*... 
               sin(m*angle(X + 1i*Y) - (sqrt(X.^2 + Y.^2)));
        end
        
        % FOR FFT
        function Argout = VectorPack(this, u, v)
            % Pack the grids in fourier domain (or Not???) into one vector
            % for ODEs solving and temporal evolution.
            
            uvec   = reshape(u, this.n^2, 1);
            vvec   = reshape(v, this.n^2, 1);
            Argout = [uvec; vvec];
        end
        
        % FOR FFT
        function [u, v] = VectorUnpack(this, vec)
            % Unpack the vectors for the ODEs (in fourier or not) into 2
            % matrices that represetns the u, v grids discretizations. 
            
            uvec = vec(1: this.n^2); 
            vvec = vec(this.n^2 + 1: end);
            u    = reshape(uvec, this.n, this.n);
            v    = reshape(vvec, this.n, this.n);   
        end
    end
end

