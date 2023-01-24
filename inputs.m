%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Inputs File~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Created by: Orfeas Emmanouil, Tatsis
%             Fernando, Cruz Ceravalls
%             Yuechen, Chen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In this file, the user modifies the inputs of the model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CHOOSE IF THE PLOTS ARE SAVED INTO GIFs & JPGs
% 1)true, 2)false
record = true;

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
c = 0.5;    % CFL safety constant

%% Wall shape

if ~strcmp(mode, 'Check_Walls')
    
    % INSERT WALL TYPE
    % 1) 'Flat',  2) 'Inclined', 3) 'Stairs', 4) 'Rounded'
    wall_type = 'Inclined';

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

    % dim = either l/2 or w/2
    formfunction = @(xnorm, dim) abs(factor*(abs(xnorm) - dim + base)) * (abs(xnorm) >= dim - base);

elseif strcmp(wall_type, 'Stairs')

    step_height = 2; %in m
    step_dis = 2; %in m
    step_num = 5; % step number
    
    % dim = either l/2 or w/2
    step_h = step_height/step_num; step_d = (step_dis*2)/step_num;   %adjusting values to the model
    formfunction = @(xnorm, dim) sum(step_h * ((abs(xnorm) >= dim - [1:step_num]*step_d)));

elseif strcmp(wall_type, 'Rounded')
    R = 2;      % radius of the circle

    % dim = either l/2 or w/2
    formfunction = @(xnorm, dim) (-sqrt(R^2 - (abs(xnorm) - dim + R).^2) + R) * (abs(xnorm) >= dim - R) ;
end

bottom_h = zeros(size(xx));  % bottom_h: distance from flat bottom
for  i=1:size(xx,2)
    bottom_h(:,i) = bottom_h(:,i) + formfunction(xx(1,i), l/2);
    for  j=1:size(xx,1)
        if formfunction(yy(j,i),w/2)>bottom_h(j,i); bottom_h(j,i) = formfunction(yy(j,i),w/2); end
    end
end

%% Source

% CHOOSE SOURCE TYPE
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
tstop = 15.0;   % max time value
ii = 1;
numplots = 3;
tplot = [1.35;3.0];

%% Vectors for circular shift

shiftp1 = circshift((1:length(x))',1);
shiftm1 = circshift((1:length(x))',-1);
shiftp2 = circshift((1:length(y))',1);
shiftm2 = circshift((1:length(y))',-1);

%% Floating Lane Lines
% They are not working correctly

if ~strcmp(mode, 'Check_Lanes')

    % SWITCH ON/OFF THE FLOATING LINES
    % 1) true  2) false
    lane_switch = false;

else
    if loop == 1
        lane_switch = true;
    else
        lane_switch = false;
    end
end

if lane_switch

    lane_n = 10;        % Number of Lanes (Olympic Games pool lanes: 10)
    lane_r = 7.5;     % Radius of Lanes [cm]

    [xc, yc, zc]=cylinder(lane_r/100);
    zc(1,:)=-l/2; zc(2,:)=l/2;
    xc = xc + d;

    l_n2 = lane_n/2;
    cur_lane = linspace(-(l_n2-1)/(l_n2), (l_n2-1)/(l_n2), lane_n-1);
    
    lane_pos = zeros(size(yy));
    lane_save(1:lane_n-1) = 0;
    for i = 1:lane_n-1
        ycall(:,:,i) = yc - cur_lane(i)*(w/2);

        grid_dist = w^2;
        for j=1:size(yy,1)
            grid_distnew = cur_lane(i)*(w/2) - yy(j,1);
            if abs(grid_distnew) <= abs(grid_dist)
                grid_dist = grid_distnew;
                lane_save(i) = j;
            end
        end
        lane_pos(lane_save(i),:) = 1;
    end

    clear l_n2 cur_lane yc lane_save grid_distnew grid_dist
end
