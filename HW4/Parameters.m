classdef Parameters
    %PARAMS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        A; % Partial x operational matrix.
        B; % Partial y operational matrix.
        C; % Laplacian operational matrix.
        A2; % Laplacian for solving the Stream function matrix.
        SolveModes = 0; 
            % What is the mode for solving for the stream function? 
            % 1. Back Slash (Implemented)
            % 2. LU decomposition (Implemented)
            % 3. bicgstab 
            % 4. gmres
            % 5. FFT spectral method
            
        % These parameters are for solving the Stream function using LU
        % decomposition. 
        L;  U;  P;
    end
    
    methods 
        function obj = Parameters(n, deltaX)
            P  = FiniteDiffMatrix([-1, 0, 1], [-1, 0, 1], n);
            PartialX  = kron(P, eye(n))./(2*deltaX);
            PartialY  = kron(eye(n), P)./(2*deltaX);
            P2 = FiniteDiffMatrix([1, -2, 1], [-1, 0, 1], n);
            Laplacian = kron(P2, eye(n)) + kron(eye(n), P2);
            Laplacian = Laplacian./(deltaX.^2);
            obj.A  = Laplacian;
            obj.B  = PartialX;
            obj.C  = PartialY;
            obj.A2 = Laplacian; 
            obj.A2(1, 1) = 2;  % Modifications on the Laplacian. 
            [obj.L, obj.U, obj.P] = lu(obj.A2);
        end
    end
    
end

