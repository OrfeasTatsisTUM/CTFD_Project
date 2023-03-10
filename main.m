%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Main File ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Created by: Orfeas Emmanouil, Tatsis
%             Fernando, Cruz Ceravalls
%             Yuechen, Chen

%% FINAL PROJECT
%  TUM - Ass. Professorship for Thermo Fluid Dynamics
%  WS022-023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program models the waves in a swimming pool with Shallow Water
% Equations using Finite Volume Methods
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all;

%% Inputs
inputs

%% Vectors for circular shift
shiftp1 = circshift((1:length(x))',1);
shiftm1 = circshift((1:length(x))',-1);
shiftp2 = circshift((1:length(y))',1);
shiftm2 = circshift((1:length(y))',-1);

%% Initial plot
postprocess;

%% Calculate
Uplot = zeros(size(U));
store = 1;

while t < tstop
    Uold = U;
    uold = u;
    vold = v;
    told = t;
    t = t + dt;
    
    % calculate lambda = |u| + sqrt(gh) used for finding flux
    lamdau = 0.5*abs(uold+uold(:,shiftm1)) +...
        sqrt(g*0.5*(Uold(:,:,1)+Uold(:,shiftm1,1)));
    lamdav = 0.5*abs(vold+vold(shiftm2,:)) +...
        sqrt(g*0.5*(Uold(:,:,1)+Uold(shiftm2,:,1)));
    lamdamax = norm([lamdau(:); lamdav(:)],Inf);
    
    dt = c*(dx/lamdamax);
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
        0.5*bsxfun(@times,Uold(:,shiftm1,:)-Uold,lamdau);
    fluxy =  0.5*(lffv+lffv(shiftm2,:,:)) - ...
        0.5*bsxfun(@times,Uold(shiftm2,:,:)-Uold,lamdav);

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

    d_plot(store) = (t>=tstop)*(d+0.6) + (store==1)*(d+0.6);
    store = store + 1;
end

%% Plots
postprocess;
 
clear dt fluxx fluxy i ii lamdau lamdav shiftp2 shiftm2 shiftm1 shiftp1 told tplot uold Uold vold ylh xlh k