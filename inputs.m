%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Inputs File~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Created by: Orfeas Emmanouil, Tatsis
%             Fernando, Cruz Ceravalls
%             Yuechen, Chen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In this file, the user modifies the inputs of the model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Record the plots to GIFs & JPGs
% 1)true, 2)false
record = false;

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

%% Wall shape

if ~strcmp(mode, 'Check_Walls')
    
    % INSERT WALL TYPE
    % 1) 'Flat',  2) 'Inclined', 3) 'Stairs', 4) 'Rounded'
    wall_type = 'Rounded';



else
    if loop == 1
        wall_type = 'Flat';
    elseif loop == 2
        wall_type = 'Inclined';
    elseif loop == 3
        wall_type = 'Stairs';
    else
        wall_type = 'Rounded';
    end
end


if strcmp(wall_type, 'Flat')
    formfunction = @(xnorm, dim) 0;

elseif strcmp(wall_type, 'Inclined')
    base = 4;      % where the inclination starts
    factor = 0.5;  % inclination value

    formfunction = @(xnorm, dim) abs(factor*(abs(xnorm) - dim + base)) * (abs(xnorm) > dim - base);

elseif strcmp(wall_type, 'Stairs')
    % The steps are 3
    steps_h = 0.8;  % step height & width (dx,dy =< steps_h =< d/3)

    formfunction = @(xnorm, dim) (steps_h) * ...
        ((abs(xnorm) >= dim - 3*steps_h) + (abs(xnorm)>= dim - 2*steps_h) + ...
        (abs(xnorm) >= dim - steps_h));

elseif strcmp(wall_type, 'Rounded')
    base = 3.5;      % where the inclination starts
    factor = 0.1;    % inclination value
    order = 2;

    formfunction = @(xnorm, dim) (factor*(abs(xnorm) - dim + base).^order) * (abs(xnorm) >= dim - base) ;

end

bottom_h = zeros(size(xx));  % bottom_h: distance from flat bottom
for  i=1:size(xx,2)
    bottom_h(:,i) = bottom_h(:,i) + formfunction(xx(1,i), l/2);
    for  j=1:size(xx,1)
        if formfunction(yy(j,i),w/2)>bottom_h(j,i); bottom_h(j,i) = formfunction(yy(j,i),w/2); end
    end
end

%% Source

% INSERT SOURCE TYPE
% 1) 'Point'  2) 'Line'
src_type = 'Point';

wave_h = 4;     % initial wave height

% position where the wave starts from (point source)
xsource = -15;  % source x position
ysource = 2.5;  % source y position
w_size = 2;     % source size - when point source the source dimensions are doubled 

if strcmp(src_type, 'Point')
    h = ones(size(xx))*d;
    h(xx >= -w_size+xsource & xx <= w_size+xsource & yy >= -w_size+ysource & yy <= w_size+ysource) = d + wave_h;
elseif strcmp(src_type, 'Line')
    h = ones(size(xx))*d;
    h(xx <= -l/2 + w_size/2) = d + wave_h;
end

% error when bottom reaches the surface
for i=1:size(xx,1)
    for j=1:size(xx,2)
        if bottom_h(i,j) > h(i,j)
            error(['Bottom goes above the water level. Wall type: '  wall_type])
        end
    end
end

h1 = h - bottom_h; % distance from the non-flat bottom until surface (with wave) 

%% Initial surface

% U is our unknown matrix. U(:,:,1)=h, U(:,:2)=hu, U(:,:,3)=hv
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

%% Vectors for circular shift

shiftp1 = circshift((1:length(x))',1);
shiftm1 = circshift((1:length(x))',-1);
shiftp2 = circshift((1:length(y))',1);
shiftm2 = circshift((1:length(y))',-1);

%% Floating Lane Lines

% SWITCH ON/OFF THE FLOATING LINES
% 1) true  2) false
lane_switch = true;

if lane_switch

    lane_n = 10;        % Number of Lanes (Olympic Games pool lanes: 10)
    lane_r = 7.5;     % Radius of Lanes [cm]

    [xc, yc, zc]=cylinder(lane_r/100);
    zc(1,:)=-l/2; zc(2,:)=l/2;
    xc = xc + d;
    for i = 1:lane_n-1
        l_n2 = lane_n/2;
        cur_lane = linspace(-(l_n2-1)/(l_n2), (l_n2-1)/(l_n2), lane_n-1);
        ycall(:,:,i) = yc - cur_lane(i)*(w/2);
    end

    clear l_n2 cur_lane yc
end