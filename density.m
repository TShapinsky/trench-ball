function [depths, densities] = density ()
clines = load('clines.mat');
clines = clines.clines;
pressureATM = 101325;
poly = [
    0,0,0, 9.9920571e02;
    1,0,0, 9.5390097e-02;
    2,0,0,-7.6186636e-03;
    3,0,0, 3.1305828e-05;
    4,0,0,-6.1737704e-08;
    0,1,0, 4.3368858e-01;
    2,1,0, 2.5495667e-05;
    3,1,0,-2.8988021e-07;
    4,1,0, 9.5784313e-10;
    0,2,0, 1.7627497e-03;
    1,2,0,-1.2312703e-04;
    2,2,0, 1.3659381e-06;
    3,2,0,-4.0454583e-09;
    0,3,0,-1.4673241e-05;
    1,3,0, 8.8391585e-07;
    2,3,0,-1.1021321e-08;
    3,3,0, 4.2472611e-11;
    4,3,0,-3.9591772e-14;
    0,0,1,-8.23082313e-01;
    0,0,2, 1.77931996e-03;
    0,0,3,-5.88155619e-05;
    0,0,4, 6.15319929e-07;
    1,0,1, 2.80832102e-03;
    2,0,1,-2.67161731e-05;
    0,1,1, 8.12062506e-04;
    0,2,1,-1.03473343e-06;
    1,1,1,-8.83528781e-06
   ];
    densities = [];
    depths = [];
    
    options = odeset('RelTol',1e-7,'AbsTol',1e-6);
    [~,~] = ode45(@compress,[0,clines(end,1)],pressureATM,options);

    function [density] = compress(depth,p)
        t = getTemp(depth);
        S = getSalinity(depth);
        density = getDensity(t,p,S);
        densities = [densities;density];
        depths = [depths,depth];
        density = density *9.80655;
    end

    function [density] = getDensity(t,p,S)
        p = p/1e6;
        density_fresh = 0;
        for C = poly(1:18,:)'
            density_fresh = density_fresh + t^C(1)*p^C(2)*S^C(3)*C(4);
        end
        density_saltdiff = 0;
        for C = poly(19:end,:)'
            density_saltdiff = density_saltdiff + t^C(1)*p^C(2)*S^C(3)*C(4);
        end
        density = density_fresh - density_saltdiff;
    end

    function [t] = getTemp(depth)
        t = interp1(clines(:,1),clines(:,3),depth,'spline','extrap');
    end

    function [S] = getSalinity(depth)
        S = interp1(clines(:,1),clines(:,2),depth,'spline','extrap');
    end

end