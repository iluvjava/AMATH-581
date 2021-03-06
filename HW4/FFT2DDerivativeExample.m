%%
clear variables 

% So here we are going to investigate how to use the FFT to take partial
% derivative on the data matrix. 

% And we are also going to try to take integration on this, and see how
% this thing behaves. 

f = @(x, y) exp(-x.^2 - y.^2);
fx = @(x, y) -2.*x.*exp(-x.^2 - y.^2);
fxy = @(x, y) 4.*x.*y.*exp(-x.^2 -y.^2);

N = 128;
Xgrid = linspace(-3, 3, N);
Ygrid = linspace(-3, 3, N);
L = 6; 
[Xs, Ys] = meshgrid(Xgrid, Ygrid);
Zs = f(Xs, Ys);
figure; imagesc(Zs); colorbar; title("f(x, y)")

ZsFourier = fft2(Zs);
kx = (2*pi/L)*(-N/2: N/2 - 1);
kx = fftshift(kx);
ky = kx.';
kx(1) = 1e-10; 
ky(1) = 1e-10;
dxZs = ifft2(i.*kx.*ZsFourier);
dxyZs = ifft2(i.*(kx.*ky).*ZsFourier);
figure; imagesc(abs(dxZs)); colorbar; title("abs(fx) Fourier")
figure; imagesc(abs(fx(Xs, Ys))); colorbar; title("Abs(fx) Analytic")
figure; imagesc(abs(dxyZs)); colorbar; title("abs(fxy) Fourier")
figure; imagesc(abs(fxy(Xs, Ys))); colorbar; title("abs(fxy) Analytic")


%% Spectral Integral
% So, we are going to take the integral of a funciton using the spectral
% method. 

fxy = @(x, y) 4.*x.*y.*exp(-x.^2 -y.^2);

N = 128;
Xgrid = linspace(-3, 3, N);
Ygrid = linspace(-3, 3, N);
L = 6; 
[Xs, Ys] = meshgrid(Xgrid, Ygrid);
Zs = fxy(Xs, Ys);
figure; imagesc(Zs); colorbar; title("Fxy");

% Taking the spectral integration 

ZsFourier = fft2(Zs); 
kx = (2*pi/L)*(-N/2: N/2 - 1);
kx = fftshift(kx);
ky = kx.';
kx(1) = 1e-5; 
ky(1) = 1e-5;
IntxyZs = ifft2(ZsFourier./(i.*kx.*ky));
figure; imagesc(abs(IntxyZs)); colorbar; title("F");









