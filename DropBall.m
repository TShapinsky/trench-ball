function [times, depths ] = DropBall(diameterBall, massBall, maxDepth, ignoreDensity, ignoreGravity)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


rEarth = 6378e3;
lat = 11.363;
lon = 142.589;
nominalG = gravitywgs84(0,lat,lon,'Exact');
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
            if isnan(densityWater)
                densityWater = pycnocline.densities(end);
            end
        end
        
        if ~ ignoreGravity
            g = 9.80665;
        else
            g = (nominalG+(2.224e-6*depth));
        end
       
        forceDrag = (1/2)* densityWater * velocity^2 * .47 * area;
        forceGravity = massBall * g;
        
        forceBuoyant = volumeBall*densityWater*g;
        
        forceEffective = forceGravity - forceDrag - forceBuoyant;
        
        
        acceleration = forceEffective/massBall;
        
        flows = [velocity; acceleration];
    end

    function [ density ] = getDensity( depth )
        density = interp1q(pycnocline.depths',pycnocline.densities,depth);
    end

    function [value, isTerminal, direction] = events(~, currentStock)
        depth = currentStock(1);
        vel = currentStock(2);
        value = [maxDepth - depth,vel];
        isTerminal = [1,1];
        direction = [-1,-1];
    end

options = odeset('Events', @events, 'RelTol',1e-10);
[times, depths] = ode23s(@dropFun, [0,60*60*8], [0;0], options);
end

