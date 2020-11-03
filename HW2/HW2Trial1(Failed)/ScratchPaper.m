Xaxis = linspace(0, sqrt(10), 100); 
Yaxis = linspace(-10, 10, 100);
[X, Y] = meshgrid(Xaxis, Yaxis);
Z = X.^2 - Y.^2; 
surf(X, Y, Z)