%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Inputs File~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%% Setup grid
% node distances
dx = 0.5;
dy = 0.5;

% pool dimensions (Olympic Games pool: 25x50x3)
w = 25;     % width of an Olympic Games pool [m]
l = 50;     % length of an Olympic Games pool [m]
d = 3;      % depth from 2 to 3 [m] (3 [m] is suggested)

% create grid
x = -l/2:dx:l/2;
y = -w/2:dy:w/2;
[xx,yy] = meshgrid(x,y);

g = 9.81;   % gravitational acceleration
c = 0.5;

%% Source
% Source Type
% 1) 'point'  2) 'line'
src_type = 'point';

% initial wave height
wave_h = 4;

% position where the wave starts from (point source)
xsource = -15;  % source x position
ysource = 2.5;  % source y position
w_size = 2;     % source size - when point source the source dimensions are doubled 

if strcmp(src_type, 'point')
    h = ones(size(xx))*d;
    h(xx >= -w_size+xsource & xx <= w_size+xsource & yy >= -w_size+ysource & yy <= w_size+ysource) = d + wave_h;
elseif strcmp(src_type, 'line')
    h = ones(size(xx))*d;
    h(xx <= -l/2 + w_size/2) = d + wave_h;
end

%% Initial surface
% U is our unknown matrix. U(:,:,1)=h,U(:,:2)=hu,U(:,:,3)=hv
U = zeros([size(h) 3]);
U(:,:,1) = h;
u = zeros(size(xx));
v = u;

%% Time values
t = 0;          % initial time
dt = 0;
tstop = 10.0;   % max time value
ii = 1;
numplots = 3;
tplot = [1.35;3.0];