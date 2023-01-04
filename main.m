% FVM for shallow water equations
clear all; close all;

%% Setup grid
dx = 0.5;
dy = 0.5;

w = 25; % width of an Olympic Games pool [m]
l = 50; % length of an Olympic Games pool [m]
d = 3; % depth from 2 to 3 [m] (3 [m] is suggested)

x = -l/2:dx:l/2;
y = -w/2:dy:w/2;
[xx,yy] = meshgrid(x,y);

g = 9.81; % gravitational acceleration
c = 0.5;

%% Source
% position where the wave starts from
xsource = -15;  
ysource = 2.5;
wave_h = 4;  % initial wave height
w_size = 2;

h = ones(size(xx))*d;
h(xx >= -w_size+xsource & xx <= w_size+xsource & yy >= -w_size+ysource & yy <= w_size+ysource) = d + wave_h;

%% Initial surface
% U is our unknown matrix. U(:,:,1)=h,U(:,:2)=hu,U(:,:,3)=hv
U = zeros([size(h) 3]);
U(:,:,1) = h;
u = zeros(size(xx));
v = u;

%% Vectors for circular shift
shiftp1 = circshift((1:length(x))',1);
shiftm1 = circshift((1:length(x))',-1);
shiftp2 = circshift((1:length(y))',1);
shiftm2 = circshift((1:length(y))',-1);

%% Initial plot
figure(1)
mesh(x,y,U(:,:,1)), colormap jet, axis([-l/2 l/2 -w/2 w/2 0 d+wave_h])
set(gca,'DataAspectRatio',[1 1 0.4])
set(gcf, 'Position',[100,50,1650,800]);
view(25,30);            %view angle
title('hit enter to continue')
text(-l/2, -w/2, 0, ['  Max Wave Height = ' num2str(wave_h)],'VerticalAlignment','bottom')
xlh = xlabel('x');
xlh.Position(1) = xlh.Position(1) - 11;
ylh = ylabel('y');
ylh.Position(2) = xlh.Position(2) + 16.5;
zlabel h;
pause;

%% Time values
t = 0;
dt = 0;
tstop = 10.0;
ii = 1;
numplots = 3;
tplot = [1.35;3.0];

Uplot = zeros([size(U)]);
styles = {'k:','k--','k-'};
store = 1;

%% Calculate
while t < tstop
    Uold = U;
    uold = u;
    vold = v;
    told = t;
    t = t + dt;
    
    % calculate lambda = |u| + sqrt(gh) used for finding flux
    lambdau = 0.5*abs(uold+uold(:,shiftm1)) +...
        sqrt(g*0.5*(Uold(:,:,1)+Uold(:,shiftm1,1)));
    lambdav = 0.5*abs(vold+vold(shiftm2,:)) +...
        sqrt(g*0.5*(Uold(:,:,1)+Uold(shiftm2,:,1)));
    lambdamax = norm([lambdau(:); lambdav(:)],Inf);
    
    dt = c*(dx/lambdamax);
    % adjust dt to produce plots at the right time
    if (ii<=length(tplot) && tplot(ii)>=told && tplot(ii)<=t+dt)
        dt = tplot(ii)-t;
        ii = ii + 1;
    end
    
    huv = Uold(:,:,2).*Uold(:,:,3)./Uold(:,:,1);
    ghh = 0.5*g*Uold(:,:,1).^2;

    % calculate (hu,hu^2+gh^2/2,huv)
    lffu = cat(3,Uold(:,:,2),Uold(:,:,2).^2./Uold(:,:,1)+ghh,huv);
    % calcualte (hv,huv,hv^2+gh^2/2)
    lffv = cat(3,Uold(:,:,3),huv,Uold(:,:,3).^2./Uold(:,:,1)+ghh);

    % calculate fluxes
    fluxx =  0.5*(lffu+lffu(:,shiftm1,:)) - ...
        0.5*bsxfun(@times,Uold(:,shiftm1,:)-Uold,lambdau);
    fluxy =  0.5*(lffv+lffv(shiftm2,:,:)) - ...
        0.5*bsxfun(@times,Uold(shiftm2,:,:)-Uold,lambdav);

    % time step
    U = Uold - (dt/dx)*(fluxx - fluxx(:,shiftp1,:)) ...
        - (dt/dy)*(fluxy - fluxy(shiftp2,:,:));
    
    %% Impose boundary conditions on h
    U(1:end,end,1) =  U(1:end,end-1,1); U(1:end,1,1) =  U(1:end,2,1);
    U(end,1:end,1) =  U(end-1,1:end,1); U(1,1:end,1) =  U(2,1:end,1);
    % on hu
    U(1:end,end,2) = -U(1:end,end-1,2); U(1:end,1,2) = -U(1:end,2,2);
    U(end,1:end,2) =  U(end-1,1:end,2); U(1,1:end,2) =  U(2,1:end,2);
    % on hv
    U(1:end,end,3) =  U(1:end,end-1,3); U(1:end,1,3) =  U(1:end,2,3);
    U(end,1:end,3) = -U(end-1,1:end,3); U(1,1:end,3) = -U(2,1:end,3);
    
    % u = hu./h;            % v = hv./h;
    u = U(:,:,2)./U(:,:,1);   v = U(:,:,3)./U(:,:,1);
    
    %% store the values for plot
    Uplot(:,:,store) = U(:,:,1);
    t_plot(store) = t+dt;
    max_h(store) = max(max(U(:,:,1)))-d;
    store = store + 1;
end

%% Plot
for i = 1:store-1
    % display a movie of height
    figure(1)
    mesh(x,y,Uplot(:,:,i)), colormap jet, axis([-l/2 l/2 -w/2 w/2 0 d+wave_h])
    set(gca,'DataAspectRatio',[1 1 0.4])
    view(25,30);            %view angle
    title(['t = ' num2str(t_plot(i)) ])
    xlh = xlabel('x');
    xlh.Position(1) = xlh.Position(1) - 11;
    ylh = ylabel('y');
    ylh.Position(2) = xlh.Position(2) + 16.5;
    zlabel h;
    text(-l/2, -w/2, 0, ['  Max Wave Height = ' num2str(max_h(i))],'VerticalAlignment','bottom')
    pause(0.001)
    set(gcf, 'Position',[100,50,1650,800]);
end

% for i = 1:store-1
%     figure(2)
%     s = pcolor(x,y,Uplot(:,:,i));
%     colormap jet
%     s.FaceColor = 'interp';
%     axis equal
%     axis([-l/2 l/2 -w/2 w/2])
%     title(['t = ' num2str(t_plot(i))])
%     xlabel('x')
%     ylabel('y')
%     pause(0.001)
%     set(gcf, 'Position',[505,150,900,550]);
% end
