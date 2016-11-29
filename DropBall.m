function [times, depths ] = DropBall(diameterBall, massBall, maxDepth, ignoreDensity, ignoreGravity)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


rEarth = 6378e3;
nominalG = 9.80665;
pycnocline = load('pycnocline.mat');

    function[flows] = dropFun(~, stocks)
        depth = stocks(1);
        velocity = stocks(2);
        
        radius = diameterBall/2;
        r = rEarth - depth;
        area = pi * radius^2;
        volumeBall = (4/3) * pi * radius^3;
        
        if ~ ignoreDensity
            densityWater = getDensity(0);
        else
            densityWater = getDensity(depth);
        end
        
        if ~ ignoreGravity
            g = nominalG;
        else
            g = (rEarth/r)^2 * nominalG;
        end
       
        forceDrag = (1/2)* densityWater * velocity^2 * .47 * area;
        forceGravity = massBall * g;
        
        forceBuoyant = volumeBall*densityWater*g;
        
        forceEffective = forceGravity - forceDrag - forceBuoyant;
        
        
        acceleration = forceEffective/massBall;
        
        flows = [velocity; acceleration];
    end

    function [ density ] = getDensity( depth )
        density = interp1q(pycnocline.depth',pycnocline.density',depth);
    end

    function [value, isTerminal, direction] = events(~, currentStock)
        depth = currentStock(1);
        value = maxDepth - depth;
        isTerminal = 1;
        direction = -1;
    end

options = odeset('Events', @events);
[times, depths] = ode45(@dropFun, [0,60*60*3], [0;0], options);
end

