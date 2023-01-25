%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Solution File~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Created by: Orfeas Emmanouil, Tatsis
%             Fernando, Cruz Ceravalls
%             Yuechen, Chen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In this file, the model is solved using the Lax-Friedrich method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Uplot = zeros(size(U));
store = 1;

while t < tstop
    told = t;
    t = t + dt;
    
    % calculate lambda = |u| + sqrt(gh) used for finding flux
    lamdau = 0.5*abs(u+u(:,shiftm1)) + sqrt(g*0.5*(h1(:,:)+h1(:,shiftm1)));
    lamdav = 0.5*abs(v+v(shiftm2,:)) + sqrt(g*0.5*(h1(:,:)+h1(shiftm2,:)));
    lamdamax = norm([lamdau(:); lamdav(:)],Inf);
    
    dt = c*(dx/lamdamax);
    % adjust dt to produce plots at the right time
    if (ii<=length(tplot) && tplot(ii)>=told && tplot(ii)<=t+dt)
        dt = tplot(ii)-t;
        ii = ii + 1;
    end
    
    huv = U(:,:,2).*U(:,:,3)./U(:,:,1);
    ghh = 0.5*g*U(:,:,1).^2;

    % calculate (hu,hu^2+gh^2/2,huv)
    lffu = cat(3,h1.*u,U(:,:,2).^2./U(:,:,1)+ghh,huv); % F(V)
    % calcualte (hv,huv,hv^2+gh^2/2)
    lffv = cat(3,h1.*v,huv,U(:,:,3).^2./U(:,:,1)+ghh); % G(V)

    if lane_switch % wrong
        S = cat(3, zeros(size(yy)), lane_r/100*(g+1)*lane_pos, lane_r/100*(g+1)*lane_pos);
    end

    % calculate fluxes
    fluxx =  0.5*(lffu+lffu(:,shiftm1,:)) - 0.5*(U(:,shiftm1,:)-U).*lamdau;
    fluxy =  0.5*(lffv+lffv(shiftm2,:,:)) - 0.5*(U(shiftm2,:,:)-U).*lamdav;

    % time step
    if lane_switch
        U = U - (dt/dx)*(fluxx - fluxx(:,shiftp1,:)) - (dt/dy)*(fluxy - fluxy(shiftp2,:,:)) + dt*S;  % wrong
    else
        U = U - (dt/dx)*(fluxx - fluxx(:,shiftp1,:)) - (dt/dy)*(fluxy - fluxy(shiftp2,:,:));
    end

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
    
    %% Validation process
    %h(x,y,t) * dx * dy we must take into consideration the nodes and multiplz so that we get the [m] unitary
    
    Val = [Val;trapz(trapz(U(:,:,1)))*(dy*dx)]; %[m]
    
    %% Store the values for plot
    Uplot(:,:,store) = U(:,:,1);
    t_plot(store) = t+dt;
    max_h(store) = max(max(U(:,:,1)))-d;
    avg_h(store) = mean(mean(abs(U(:,:,1))-d));

    d_plot(store) = (t>=tstop)*(d+0.6) + (store==1)*(d+0.6);
    store = store + 1;
end

% create matrix to plot the wall shapes
if ~strcmp(wall_type, 'Flat')
    bottom_plot = linspace(-l/2,l/2,size(d_plot,2));
    for  i=1:size(d_plot,2); d_plot(i) = d_plot(i) + formfunction(bottom_plot(i),l/2); end
end