
%clear;

[times1, depths1] = DropBall(.2183, 7, 10916,0,0);
[times2, depths2] = DropBall(.2183, 7, 10916,1,1);

%h = axes;
%set(h, 'Ydir', 'reverse');
figure 
hold on;
plot(depths1(10:end,1), depths1(10:end,2),'LineWidth',3);
plot(depths2(10:end,1), depths2(10:end,2),'LineWidth',3);
axis([100,10916,depths2(end,2)-.1,depths1(end,2)+.1]);
AX = legend('\bfControl Model','\bfComplex Model');
set(gca,'FontSize',15); 
hold off;
title('Terminal Velocity Comparison','FontSize',25);

xlabel('\bfDepth (m)','FontSize',15);
ylabel('\bfVelocity (m/s)','FontSize',15);