function boundries
clear all
clc



% Create plots
t = tiledlayout(2,2);

nexttile
%Figure1
xline(5)
grid on
xlim([0 6]);
ylim([0 3]);
title("a")

nexttile
%Figure2
th = linspace( -pi/2, 0, 100);
R = 1;  %or whatever radius you want
x = R*cos(th) + 4;
y = R*sin(th) + 1;
plot(x,y); axis equal;
grid on
xlim([0 6]);
ylim([0 3]);
title("b")

nexttile
%Figure3
syms x;
y=piecewise(x<4,0, 4<x<4.2,0.2, 4.2<x<4.4,0.4, 4.4<x<4.6,0.6, 4.6<x<4.8,0.8, 4.8<x<5,1, 5<x, x);
fplot(y);
xlabel('X-axis')
ylabel('Y-axis')
grid on;
xlim([0 6]);
ylim([0 3]);
title("c")

nexttile
%Figure4
fplot(@(x) (x)-4,[4 5], "b");
grid on
xlim([0 6]);
ylim([0 3]);
title("d")















end

