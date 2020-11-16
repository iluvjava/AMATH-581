clear variables; 

%% Problem 1. 
% Matrix Derivative and Laplacian, Periodic condition. 
N = 8; 

% 1D operator: 
P  = FiniteDiffMatrix([1 -2 1], [-1, 0, 1], 8);  % second derivatice second order central periodic. 
P2 = FiniteDiffMatrix([1, 0, 1], [-1, 0, 1], 8); 

% 2D operator: 
Laplacian = kron(eye(N), P) + kron(P, eye(N));
DeltaX = 20/N;
Laplacian = Laplacian./DeltaX^2;

PartialX2d = kron(eye(N), P2); 
PartialX2d = PartialX2d./(2*DeltaX);

PartialY2d = kron(P2, eye(N)); 
PartialY2d = PartialY2d./(2*DeltaX);

A1 = Laplacian;
A2 = PartialX2d;
A3 = PartialY2d;


%% Problem 2
load("Fmat.mat");
load("permvec.mat");

CenterBlocks = Fmat(161:240, 161:240);
BlockVec = Transform(CenterBlocks, 1);
NewBlockVec = zeros(20, 20, 16);
for I = 1:16
    J = permvec(I);
    NewBlockVec(:, :, I) = BlockVec(:, :, J);
end
CenterBlocksDecrypted = Transform(NewBlockVec, 2);

FmatDecrypted = Fmat; 
FmatDecrypted(161: 240, 161: 240) = CenterBlocksDecrypted; 
imshow(abs(FmatDecrypted)./max(abs(FmatDecrypted)));
A4 = abs(FmatDecrypted);
A5 = abs(ifft2(ifftshift(FmatDecrypted)));
imshow(abs(A5)./max(abs(A5)));
