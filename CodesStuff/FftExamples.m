clear variables; close all;
L  = 10;
N  = 2^8;
x2 = linspace(-L/2, L/2, N + 1);  % Query points. 
x  = x2(1:N);  % Trim off the last point because of periodic conditions. 

u = exp(-x.^2)% cos(x).*exp(-x.^2/25);
U_Fourier = fft(u);

k = (2*pi/L)*(-N/2: N/2 - 1);  % The lower infinite and upper inifity on the fourier transform. 
k = fftshift(k);  % Must shift this or it's not working. 

figure(1);
plot(x, u); hold on;

% Taking derivative on the Fourier Space it's gonna be like: 

dU_F  =  i.*k.*U_Fourier;
dU2_F = (i.*k).^2.*U_Fourier;
dU3_F = (i.*k).^3.*U_Fourier;

dU    = ifft(U_Fourier);
plot(x, real(dU));
plot(x, real(ifft(dU_F)));
plot(x, real(ifft(dU2_F)));
plot(x, real(ifft(dU3_F)))

