%clf;
%clear;

[times, depths] = DropBall(.2183, 7, 10916,1,1);

%h = axes;
%set(h, 'Ydir', 'reverse');
hold on;
plot(times / 60, depths(:,1));

xlabel('Time (min)');
ylabel('Depth (m)');