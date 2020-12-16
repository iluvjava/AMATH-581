function outArg = WriteFrames(framer, fileName)
    vw = VideoWriter(fileName);
    open(vw);
    for k = 1: length(framer)
       writeVideo(vw, framer(k));
       im          = frame2im(framer(k));
       [imind, cm] = rgb2ind(im, 265);
       imind = uint8(imind);
       % Write to the GIF File 
       if k == 1 
           imwrite(imind, cm, strcat(fileName, ".gif"), 'gif', "DelayTime", 1/30 ,'Loopcount', inf);
       else 
           imwrite(imind, cm, strcat(fileName, ".gif"), 'gif', "DelayTime", 1/30, 'WriteMode', 'append'); 
       end 
       
    end
    close(vw);
    outArg = 1; 
end