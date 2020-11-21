function Psi = SolveForPsi(params, w)
    % 
    Psi = 0;
    A2  = params.A2;  % This is the matrix we wanna solve. 
    L = params.L;
    U = params.U; 
    P = params.P;
    tic;
    switch params.SolveModes
        case 1 % BackSlash
            Psi = A2\w;
            
        case 2 % LU
            Psi = U\(L\(P*w));
            
        case 3 % Biconjugate Gradient Stabalized method. 
            Psi = bicgstab(A2, w, params.BicgstabTOL, 500);
            
        case 4 % GMRES 
            Psi = gmres(A2, w, [] ,params.GemresTOL, 500);
            
        case 5 % FFT 2D Solve
            N = params.n; 
            L = params.l;  % L changed, not the L for LU decomposition anymore
            w = reshape(w, N, N);
            WFourier = fft2(w);
            kx = fftshift((2*pi/L).*(-N/2: (N/2 - 1)));
            kx(1) = 1e-6;
            ky = kx';
            Psi = real(ifft2(-WFourier./(kx.^2 + ky.^2)));
            Psi = reshape(Psi, N*N, 1);
    end
    TimeTransgressed = toc;
    params.TimeStats.add(TimeTransgressed);
end

% function trimmed = TrimOffBoundary(w, n)
%   % Trimm off the periodic boundary condition so that the vector is
%   % suitable for FFT transform with periodic boundary condition.
%   Matrix = reshape(w, [n, n]);
%   Matrix = Matrix(1:end - 1, 1: end - 1);
%   trimmed = reshape(Matrix, n - 1, n - 1);
% 
% end
% 
% function PadBoundary = PadBoundary(w, n)
%   % Padd repeated rows and coumn and then add them back to the vector.
%   Matrix = reshape(w, [n - 1, n - 1]);
%   Matrix(:, end + 1) = Matrix(:, 1);
%   Matrix(end + 1, :) = Matrix(1, :);
%   PadBoundary = reshape(Matrix, n*n, 1);
% end