filename = 'Both_plots.gif';
for i = 1:store-1

    % display a movie of height
    figure(1)
    for k=1:2
        subplot(1,2,k)
        mesh(x,y,Uplot(:,:,i)), colormap jet, axis([-l/2 l/2 -w/2 w/2 0 d+wave_h])
        hold on
        plot3([-l/2,linspace(-l/2,l/2,size(d_plot,2)-2),l/2],zeros(size(d_plot)),d_plot,'k','LineWidth',1.5)
        if k == 1
            hold on
            plot3(zeros(size(d_plot)),[-w/2,linspace(-w/2,w/2,size(d_plot,2)-2),w/2],d_plot,'k','LineWidth',1.5)
        end
        hold off
        set(gca,'DataAspectRatio',[1 1 0.4])
        if k==1
            view(25,30);
        else
            view(0,0);
        end
        title(['t = ' num2str(t_plot(i))  ' [s]'])
        if k == 1
            xlh = xlabel('x');   xlh.Position(1) = xlh.Position(1) - 11;
            ylh = ylabel('y');   ylh.Position(2) = xlh.Position(2) + 16.5;
        else
            xlabel('x');
        end
        zlabel h;
        text(-l/2, -w/2, 0, ['  Max Wave Height = ' num2str(max_h(i)) ' [m]'],'VerticalAlignment','bottom')
        pause(0.001)
        set(gcf, 'Position',[50,50,1800,800]);
    end

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

% filename = '3D.gif';
% for i = 1:store-1
% 
%     % display a movie of height
%     figure(2)
%     mesh(x,y,Uplot(:,:,i)), colormap jet, axis([-l/2 l/2 -w/2 w/2 0 d+wave_h])
%     hold on
%     plot3([-l/2,linspace(-l/2,l/2,size(d_plot,2)-2),l/2],zeros(size(d_plot)),d_plot,'k','LineWidth',1.5)
%     hold off
%     set(gca,'DataAspectRatio',[1 1 0.4])
%     view(25,30);
%     title(['t = ' num2str(t_plot(i))  ' [s]'])
%     xlh = xlabel('x');   xlh.Position(1) = xlh.Position(1) - 11;
%     ylh = ylabel('y');   ylh.Position(2) = xlh.Position(2) + 16.5;
%     zlabel h;
%     text(-l/2, -w/2, 0, ['  Max Wave Height = ' num2str(max_h(i))],'VerticalAlignment','bottom')
%     pause(0.001)
%     set(gcf, 'Position',[50,50,1800,800]);
% 
%     %Record into a GIF
%     drawnow
%     frame= getframe(gcf);
%     im= frame2im(frame);
%     [imind,cm] = rgb2ind(im,64);
%     if i == 1
%         imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
%     else
%         imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0);
%     end
% end

% filename = '2D_xz.gif';
% for i = 1:store-1
%     figure(3)
%     mesh(x,y,Uplot(:,:,i)), colormap jet, axis([-l/2 l/2 -w/2 w/2 0 d+wave_h])
%     hold on
%     plot3([-l/2,linspace(-l/2,l/2,size(d_plot,2)-2),l/2],zeros(size(d_plot)),d_plot,'k','LineWidth',1.5)
%     hold off
%     set(gca,'DataAspectRatio',[1 1 0.4])
%     view(0,0);            %view angle
%     title(['t = ' num2str(t_plot(i))  ' [s]'])
%     xlabel('x');
%     zlabel h;
%     text(-l/2, -w/2, 0, ['  Max Wave Height = ' num2str(max_h(i))],'VerticalAlignment','bottom')
%     pause(0.001)
%     set(gcf, 'Position',[50,50,1800,800]);
% 
%     %Record into a GIF
%     drawnow
%     frame= getframe(gcf);
%     im= frame2im(frame);
%     [imind,cm] = rgb2ind(im,64);
%     if i == 1
%         imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
%     else
%         imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0);
%     end
% end

% filename = '2D_xy.gif';
% for i = 1:store-1
%     figure(4)
%     s = pcolor(x,y,Uplot(:,:,i));
%     colormap jet
%     s.FaceColor = 'interp';
%     axis equal
%     axis([-l/2 l/2 -w/2 w/2])
%     title(['t = ' num2str(t_plot(i))])
%     xlabel('x')
%     ylabel('y')
%     pause(0.001)
%     set(gcf, 'Position',[50,50,1800,800]);
%
%     %Record into a GIF
%     drawnow
%     frame= getframe(gcf);
%     im= frame2im(frame);
%     [imind,cm] = rgb2ind(im,64);
%     if i == 1
%         imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
%     else
%         imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0);
%     end
% end

figure(5)
plot(t_plot,max_h,'k');
xlabel('t [s]');
ylabel ('Max wave height [m]');
saveas(gcf,'Max_Wave_Height.jpg')
