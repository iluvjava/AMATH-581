[D, chebPoints] = cheb(20);
D2 = D^2;
b = -2.*D2(:, 1) + 2.*D2(:, end);
b = b(2: end - 1);
D2Tilde = D2(2: end - 1, 2: end - 1);
plot(chebPoints(2: end - 1), (D2Tilde)\b);
saveas(gcf, "cheb dirichlet boundary", "png");