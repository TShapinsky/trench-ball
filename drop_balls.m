%function drop_balls()
    %densities = 1075:2.5:1150;
    %diameters = .2183:.1:3;
    densities = 1075:1:1200;
    diameters = .1:.01:.75;
    differences = zeros(size(diameters,2),size(densities,2));
    for dens = 1:size(densities,2)
        parfor dia = 1:size(diameters,2)
            r = diameters(dia)/2;
            density = densities(dens);
            mass = 4/3*pi*r^3*density;
            [timesS,depthsS] = DropBall(r*2,mass,10916,0,0);
            [timesC,depthsC] = DropBall(r*2,mass,10916,1,1);
            if depthsC(end,1) < 10916
                differences(dia,dens) = NaN;
            else
                differences(dia,dens) = timesC(end) - timesS(end);
            end
        end
        fprintf('%d/%d\n',dens,size(densities,2));
    end
    differences = differences./60;
    pcolor(densities,diameters,differences);
    grid off;
    shading interp;
    hold on;
    [C,h] = contour(densities,diameters,differences);
    hold off;
    h.LevelList = [.5,1,5,10,30,60,120,240,360];
    th = clabel(C,h);
    %h.TextList  = ['30 Seconds', '1 Minute', '5 Minutes','10 Minutes','30 Minutes', '1 Hour', '2 Hours'];
    xlabel('Density (kg/m^3)');
    ylabel('Diameter (m)');
    title('Control Model vs. Complex Model?');
    cb = colorbar;
    title(cb,'Time (min)');
    set(gca,'FontSize',15);
%end