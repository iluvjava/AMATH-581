function null = VisualizeProblem(u, v, X, Y)
    switch nargin
        case 2  
            subplot(2, 1, 1);

            pcolor(u); shading interp; title("U_t")
            grid on
            pbaspect([1 1 1]);

            subplot(2, 1, 2);
            pcolor(v); shading interp; title("V_t")
            grid on
            pbaspect([1 1 1]);

            null = nan;
        case 4
            subplot(2, 1, 1);

            pcolor(X, Y, u); shading interp; title("U_t")
            grid on
            pbaspect([1 1 1]);

            subplot(2, 1, 2);
            pcolor(X, Y, v); shading interp; title("V_t")
            grid on
            pbaspect([1 1 1]);
            
    end
end