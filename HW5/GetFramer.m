function frammer = GetFramer()
    % For movie, figure is invisible 
    figure("visible", "off");
    axis image
    x0     = 0; 
    y0     = 0; 
    width  = 400; 
    height = 800;
    set(gcf,'units','points','position',[x0,y0,width,height]);
    frammer = struct('cdata',[],'colormap',[]);
end