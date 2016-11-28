clf;
clear;

[times, depths] = DropBall(.2183, 7.26);

figure;
h = axes;
plot(times / 60, depths(:,1));
set(h, 'Ydir', 'reverse');

xlabel('Time (min)');
ylabel('Depth (m)');