function [ dep,dens ] = compress_water(  )
%COMPRESS_WATER Summary of this function goes here
%   Detailed explanation goes here
    rEarth = 6378e3;
    nominalDensity = 1025;
    nominalG = 9.80665;
    pressureATM = 101325;
    wd = [];
    tp = [];
    dep = [];
    halocline = load('halocline');
    function [flows] = pressure_dq(t,y)
        pressure =  y;
        r = rEarth - t;
        g =  (rEarth/r)^2 * nominalG;
        density = (1 - get_compressibility(pressure,t))*nominalDensity;
        dep = [dep,t];
        wd = [wd,density];
        tp = [tp, t];
        flows = [density*g];
    
    end

    function [volume] = compression_water(p)
        b = 4.58e-10;
        p = p -pressureATM;
        volume = -b*p;
    end

    function [Cw] = get_compressibility(pressure, depth)
        psi = 6894.75729; %pascal/psi
        pressure = pressure/psi;
        T = getThermocline(depth);
        S = getHalocline(depth);
        m1 = 7.033;
        m2 = 541.5;
        m3 = -537;
        m4=403.3e3;
        Cw = (m1*pressure + m2*S + m3*T + m4)^-1;%psi^-1
        Cw = Cw/psi;
        
    end

    function [T] = getThermocline(depth)
        S = 20+.338;
        T = -.338+(S*f(depth))/(1.485e-4*S*depth+f(depth));
        function [y] = f(depth)
            y = 1+exp(-0.016*depth+1.244);
        end
        T = T*(9/5)+32;
    end

    function [S] = getHalocline(depth)
        S = interp1(halocline.Depthm,halocline.Salinitypsu,depth,'pchip',halocline.Salinitypsu(end));
    end
    options = odeset('RelTol',1e-6,'AbsTol',1e-4);
    [d,y] = ode45(@(t,y) pressure_dq(t,y),[0,11e3],[pressureATM],options);
    y = [y,y - d*nominalDensity*nominalG];
    p = y(:,2)./y(:,1);
    plot(d,y(:,1));
    %plot(tp,wd./nominalDensity./nominalG);
    max(wd./nominalDensity./nominalG)
    max(y(:,1))
    dens = wd;
end

