% Let's use the Cheb to take some derivatives, so we know more about it. 

f     = @(x) sin(x); 
df    = @(x) cos(x);
xs    = linspace(-1, 1, 100);

[DCheb, ChebGrid] = cheb(20);


dfCheb = DCheb*f(ChebGrid);
figure; 
plot(ChebGrid, dfCheb, "o"); hold on 
plot(xs, df(xs));

% yeah, it's pretty good. 



