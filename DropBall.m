function [times, depths ] = DropBall(diameterBall, massBall)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


rEarth = 6378e3;
nominalG = 9.80665;

    function[flows] = dropFun(~, stocks)
        depth = stocks(1);
        velocity = stocks(2);
        
        radius = diameterBall/2;
        densityWater = 1029;%getDensity(depth);
        r = rEarth - depth;
        g = (rEarth/r)^2 * nominalG;
        %g = nominalG;
        area = pi * radius^2;
        volumeBall = (4/3) * pi * radius^3;
       
        forceDrag = (1/2)* densityWater * velocity^2 * .5 * area;
        forceGravity = massBall * g;
        
        forceBuoyant = volumeBall*densityWater;
        
        forceEffective = forceGravity - forceDrag - forceBuoyant;
        
        
        acceleration = forceEffective/massBall;
        
        flows = [velocity; acceleration];
    end
options = odeset('RelTol',1e-2);
[times, depths] = ode45(@dropFun, [0,60*60], [0;0], options);
end

