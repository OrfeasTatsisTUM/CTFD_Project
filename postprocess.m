%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Outputs File~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Created by: Orfeas Emmanouil, Tatsis
%             Fernando, Cruz Ceravalls
%             Yuechen, Chen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file visualises the outputs of the solution file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


set(0,'defaultfigurecolor',[1 1 1])

if t == 0
    %% Show Inputs
    fprintf('Pool size:\t\t\t\t %s x', num2str(l)); fprintf(' %s x', num2str(w)); fprintf(' %s [m]\n', num2str(d));
    fprintf('Node distances:\n'); fprintf(' dx:%s [cm]  ', num2str(dx*100)); fprintf('dy:%s [cm]\n\n', num2str(dy*100));
    fprintf('Wall type:\t\t\t\t %s\n\n', wall_type)
    fprintf('Source type:\t\t\t %s\n', src_type)
    fprintf(' Initial Wave Height:\t %s [m]\n', num2str(wave_h))
    if strcmp(src_type, 'Point')
        fprintf(' Initial Wave Position:\n')
        fprintf('  x:%s [m]', num2str(xsource));  fprintf('  y:%s [m]\n', num2str(ysource));
        fprintf(' Source size:\t\t\t %s x', num2str(w_size)); fprintf(' %s [m]\n\n', num2str(w_size));
    end
    fprintf('Duration:\t\t\t\t %s [s]\n\n', num2str(tstop))
    if lane_switch
        fprintf('Lane Lines:\t\t\t\t Activated\n')
        fprintf('Number of Lanes:\t\t %s\n', num2str(lane_n))
        fprintf('Radius of Lines:\t\t %s [mm]\n', num2str(lane_r*100))
    else
        fprintf('Lane Lines:\t\t\t\t Deactivated\n')
    end
   
    %% Initial plot
    %     if strcmp(mode, 'Simple')
    %         figure(1)
    %         for k = 1:2
    %             subplot(1,2,k)
    %             mesh(x,y,U(:,:,1)), colormap jet, axis([-l/2 l/2 -w/2 w/2 0 d+wave_h])
    %             if k == 1
    %                 if lane_switch
    %                     for iii = 1:lane_n-1
    %                         hold on, s = surf(zc,ycall(:,:,iii),xc); set(s,'edgecolor','none','facecolor','g')
    %                     end
    %                     hold off
    %                 end
    %             end
    %             set(gca,'DataAspectRatio',[1 1 0.4])
    %             set(gcf, 'Position',[50,50,1800,800]);
    %             if k==1
    %                 view(25,30);
    %             else
    %                 view(0,0);
    %             end
    %             title('hit enter to continue')
    %             text(-l/2, -w/2, 0, ['  Max Wave Height = ' num2str(wave_h)  ' [m]'],'VerticalAlignment','bottom')
    %             if k == 1
    %                 xlh = xlabel('x');   xlh.Position(1) = xlh.Position(1) - 11;
    %                 ylh = ylabel('y');   ylh.Position(2) = xlh.Position(2) + 16.5;
    %             else
    %                 xlabel('x');
    %             end
    %             zlabel h;
    %         end
    %         pause;
    %     end
else


    wall_plot = [-l/2,linspace(-l/2,l/2,size(d_plot,2)-2),l/2];
    if strcmp(wall_type, 'Stairs')
        for i = 1:size(d_plot,2)-1
            if (d_plot(i) ~= d_plot(i+1))
                wall_plot(i+1) = wall_plot(i);
            end
        end
    end

    %% Final plots
    if strcmp(mode, 'Simple')

        %         if record; filename = 'Both_plots.gif'; end
        %         for i = 1:store-1
        %
        %             % display a movie of height
        %             figure(1)
        %             for k=1:2
        %                 subplot(1,2,k)
        %                 mesh(x,y,Uplot(:,:,i)), colormap jet, axis([-l/2 l/2 -w/2 w/2 0 d+wave_h])
        %                 hold on
        %                 plot3(wall_plot,zeros(size(d_plot)),d_plot,'k','LineWidth',1.5)
        %                 if k == 1
        %                     hold on
        %                     plot3(zeros(size(d_plot)),[-w/2,linspace(-w/2,w/2,size(d_plot,2)-2),w/2],d_plot,'k','LineWidth',1.5)
        %                     if lane_switch
        %                         for iii = 1:lane_n-1
        %                             hold on, s = surf(zc,ycall(:,:,iii),xc); set(s,'edgecolor','none','facecolor','g')
        %                         end
        %                     end
        %                 end
        %                 hold off
        %                 set(gca,'DataAspectRatio',[1 1 0.4])
        %                 if k==1
        %                     view(25,30);
        %                 else
        %                     view(0,0);
        %                 end
        %                 title(['t = ' num2str(t_plot(i))  ' [s]'])
        %                 if k == 1
        %                     xlh = xlabel('x');   xlh.Position(1) = xlh.Position(1) - 11;
        %                     ylh = ylabel('y');   ylh.Position(2) = xlh.Position(2) + 16.5;
        %                 else
        %                     xlabel('x');
        %                 end
        %                 zlabel h;
        %                 text(-l/2, -w/2, 0, ['  Max Wave Height = ' num2str(max_h(i)) ' [m]'],'VerticalAlignment','bottom')
        %                 pause(0.001)
        %                 set(gcf, 'Position',[50,50,1800,800]);
        %             end
        %
        %             if record
        %                 %Record into a GIF
        %                 drawnow
        %                 frame= getframe(gcf);
        %                 im= frame2im(frame);
        %                 [imind,cm] = rgb2ind(im,64);
        %                 if i == 1
        %                     imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
        %                 else
        %                     imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0);
        %                 end
        %             end
        %         end


        if record; filename = '3D.gif'; end
        for i = 1:store-1

            % display a movie of height
            figure(2)
            mesh(x,y,Uplot(:,:,i)), colormap jet, axis([-l/2 l/2 -w/2 w/2 0 d+wave_h])
            hold on
            plot3(wall_plot,zeros(size(d_plot)),d_plot,'k','LineWidth',1.5)
            hold on
            plot3(zeros(size(d_plot)),[-w/2,linspace(-w/2,w/2,size(d_plot,2)-2),w/2],d_plot,'k','LineWidth',1.5)
            if lane_switch
                for iii = 1:lane_n-1
                    hold on, s = surf(zc,ycall(:,:,iii),xc); set(s,'edgecolor','none','facecolor','g')
                end
            end
            hold off
            set(gca,'DataAspectRatio',[1 1 0.4])
            view(25,30);
            title(['t = ' num2str(t_plot(i))  ' [s]'])
            xlh = xlabel('x');   xlh.Position(1) = xlh.Position(1) - 11;
            ylh = ylabel('y');   ylh.Position(2) = xlh.Position(2) + 16.5;
            zlabel h;
            text(-l/2, -w/2, 0, ['  Max Wave Height = ' num2str(max_h(i))],'VerticalAlignment','bottom')
            pause(0.001)
            set(gcf, 'Position',[50,50,1800,800]);

            if record
                %Record into a GIF
                drawnow
                frame= getframe(gcf);
                im= frame2im(frame);
                [imind,cm] = rgb2ind(im,64);
                if i == 1
                    imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
                else
                    imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0);
                end
            end
        end

        %         if record; filename = '2D_xz.gif'; end
        %         for i = 1:store-1
        %             figure(3)
        %             mesh(x,y,Uplot(:,:,i)), colormap jet, axis([-l/2 l/2 -w/2 w/2 0 d+wave_h])
        %             hold on
        %             plot3(wall_plot,zeros(size(d_plot)),d_plot,'k','LineWidth',1.5)
        %             hold off
        %             set(gca,'DataAspectRatio',[1 1 0.4])
        %             view(0,0);            %view angle
        %             title(['t = ' num2str(t_plot(i))  ' [s]'])
        %             xlabel('x');
        %             zlabel h;
        %             text(-l/2, -w/2, 0, ['  Max Wave Height = ' num2str(max_h(i))],'VerticalAlignment','bottom')
        %             pause(0.001)
        %             set(gcf, 'Position',[50,50,1800,800]);
        %
        %             if record
        %                 Record into a GIF
        %                 drawnow
        %                 frame= getframe(gcf);
        %                 im= frame2im(frame);
        %                 [imind,cm] = rgb2ind(im,64);
        %                 if i == 1
        %                     imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
        %                 else
        %                     imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0);
        %                 end
        %             end
        %         end

        %         if record; filename = '2D_xy.gif'; end
        %         for i = 1:store-1
        %             figure(4)
        %             s = pcolor(x,y,Uplot(:,:,i));
        %             colormap jet
        %             s.FaceColor = 'interp';
        %             axis equal
        %             axis([-l/2 l/2 -w/2 w/2])
        %             title(['t = ' num2str(t_plot(i))])
        %             xlabel('x')
        %             ylabel('y')
        %             pause(0.001)
        %             set(gcf, 'Position',[50,50,1800,800]);
        %
        %             if record
        %                 drawnow
        %                 frame= getframe(gcf);
        %                 im= frame2im(frame);
        %                 [imind,cm] = rgb2ind(im,64);
        %                 if i == 1
        %                     imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
        %                 else
        %                     imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0);
        %                 end
        %             end
        %         end

    end

    figure(5)
    if strcmp(mode, 'Check_Walls')
        plot(t_plot,max_h,'DisplayName',wall_type);
        hold on
        if loop==1
            legend(wall_type)
            set(gcf, 'Position',[50,50,1800,800]);
        end
    elseif strcmp(mode, 'Check_Lanes')
        plot(t_plot,max_h,'DisplayName',['Lanes Enabled:  ' num2str(lane_switch)]);
        hold on
        if loop==1
            legend(['Lanes Enabled:  ' num2str(lane_switch)])
            set(gcf, 'Position',[50,50,1800,800]);
        end
    else
        plot(t_plot,max_h,'DisplayName',wall_type);
    end
    xlim([0 tstop]);
    xlabel('t [s]');
    ylabel ('Max wave height [m]');
    if record; saveas(gcf,'Max_Wave_Height.jpg'); end

    if strcmp(mode, 'Check_Walls')
        figure(6)
        subplot(4,1,loop)
        plot(wall_plot,d_plot,'LineWidth',1.5);
        xlim([0 l/2]); ylim([0 d])
        set(gcf, 'Position',[50,50,900,900]);
        title(wall_type)
        if record; saveas(gcf,'Wall_Shape.jpg'); end
    end

    figure(7)
    
    if strcmp(mode, 'Check_Walls')
        plot(t_plot,avg_h,'DisplayName',wall_type);
        hold on
        if loop==1
            legend(wall_type)
            set(gcf, 'Position',[50,50,1800,800]);
        end
    elseif strcmp(mode, 'Check_Lanes')
        plot(t_plot,avg_h,'DisplayName',['Lanes Enabled:  ' num2str(lane_switch)]);
        hold on
        if loop==1
            legend(['Lanes Enabled:  ' num2str(lane_switch)])
            set(gcf, 'Position',[50,50,1800,800]);
        end
    else
        plot(t_plot,avg_h,'DisplayName',wall_type);
    end
    xlim([0 tstop]);
    xlabel('t [s]');
    ylabel ('Average wave height [m]');
    if record; saveas(gcf,'Average_Wave_Height.jpg'); end

end
