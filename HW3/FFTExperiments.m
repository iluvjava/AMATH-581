close all;
[X, map, alpha] = imread("testImage.png");

figure;
X = double(X);
X = 0.2126*X(:, :, 1) + 0.7152*X(:, :, 2) + 0.0722*X(:, :, 3);
imshow(X./max(X)); 

X_fft = fft2(X);
X_fftShifted = fftshift(X_fft);
X_fftShifted(1: 1000, :) = 0;
X_fftShifted(:, 1: 1000) = 0;
X_fftShifted(end - 1000: end, :) = 0;
X_fftShifted(:, end - 1000: end) = 0;

X_fft = fftshift(X_fftShifted);

figure;
imshow(real(X_fftShifted))

X_ifft = ifft2(X_fft);

figure;
Recovered = X_ifft; 
Recovered = Recovered./max(Recovered);

imshow(real(Recovered));