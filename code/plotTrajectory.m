function [] = plotTrajectory(f_cameraTrajectory,f_trackingP,camOrientations,camLocations,...
            state,image,landmarksScatter,landmarksHistoryScatter,cam,trajectory,...
            b_save_GIF,filename_GIF_traj,keypointCount,inlierIdx,frameCount,range)
%PLOTTRAJECTORY Summary of this function goes here
%   Detailed explanation goes here

figure(f_cameraTrajectory);
title('Trajectory and Triangulated Keypoints');
    % calculate average distance of landmarks (d=mean(vecnorm(state.X'));)
    d = 0;
    for vec_i = 1:size(state.X,2)
        d = d + norm(state.X(vec_i,:));
    end
    d = d / size(state.X,2);
    % adjust axes to follow camera
    xlim([camLocations(end,1)-0.9*d,camLocations(end,1)+0.9*d]); zlim([camLocations(end,3)-0.4*d,camLocations(end,3)+1.4*d]);
    % plot updated landmarks
    landmarksHistoryScatter.XData = [landmarksHistoryScatter.XData state.X(:,1)']; 
    landmarksHistoryScatter.YData = [landmarksHistoryScatter.YData state.X(:,2)'];
    landmarksHistoryScatter.ZData = [landmarksHistoryScatter.ZData state.X(:,3)'];
    landmarksScatter.XData = state.X(:,1); 
    landmarksScatter.YData = state.X(:,2); 
    landmarksScatter.ZData = state.X(:,3);
    % plot the estimated trajectory.
    set(trajectory, 'XData', smooth(camLocations(:,1)), ...
                    'YData', smooth(camLocations(:,2)), ...
                    'ZData', smooth(camLocations(:,3)));
    cam.Location = camLocations(end,:);
    cam.Orientation = camOrientations(:,:,end);
    drawnow
    
figure(f_trackingP);
    imshow(image); hold on;
    scatter(state.P(~inlierIdx,1), state.P(~inlierIdx, 2), 15, 'r','+' );
    scatter(state.P(inlierIdx,1), state.P(inlierIdx, 2), 15, 'g','+' );
%     % Plot Keypoint Tracks
%     for i = 1:length(state.P)
%         plot(state.F_P{i}(:,1),state.F_P{i}(:,2),'-k');
%     end
    hold off;

% Save in a GIF
if b_save_GIF
    % Save with 2 subplots
    f_GIF = figure(6);

    delete(subplot(2,2,1))
    delete(subplot(2,2,2))
    % title('Monocular state estimation');

    % Trajectory
    h(1)=subplot(2,2,1); 
    title('Trajectory and Triangulated Keypoints');
    % if frameCount == range(1)%n == 1 
        copyobj(allchild(get(f_cameraTrajectory,'CurrentAxes')),h(1));
    % end

    % adjust axes to follow camera 
    xlim([camLocations(end,1)-0.6*d,camLocations(end,1)+0.6*d]); zlim([camLocations(end,3)-0.5*d,camLocations(end,3)+1*d]);
    landmarksScatter.XData = state.X(:,1); 
    landmarksScatter.YData = state.X(:,2); 
    landmarksScatter.ZData = state.X(:,3);
    set(trajectory, 'XData', smooth(camLocations(:,1)), 'YData', ...
    smooth(camLocations(:,2)), 'ZData', smooth(camLocations(:,3)));
    cam.Location = camLocations(end,:);
    cam.Orientation = camOrientations(:,:,end);
    % set viewpoint
    view(0, 0);
    set(gca, 'CameraUpVector', [0, 0, 1]);

    % Camera view with tracks
    h(2)=subplot(2,1,2);
        imshow(image); hold on;
        title('Live Image with Tracked Keypoints');
        scatter(state.P(~inlierIdx(1:min(length(inlierIdx),length(state.P))),1), ...
                state.P(~inlierIdx(1:min(length(inlierIdx),length(state.P))), 2), 15, 'r','+' );
        scatter(state.P(inlierIdx(1:min(length(inlierIdx),length(state.P))),1), ...
                state.P(inlierIdx(1:min(length(inlierIdx),length(state.P))), 2), 15, 'g','+' );
        hold off;
    subplot(2,2,2);
        plot((range(1)-1):frameCount,keypointCount,'-');
        xlim([max([1,frameCount-20]),frameCount]);
        title('Number of Tracked Keypoints');

    % Add global title
%     figure(6)
%     ax=axes('Units','Normal','Position',[.075 .075 .85 .85],'Visible','off');
%     set(get(ax,'Title'),'Visible','on')
%     title('Camera Trajectory and Triangulated Landmarks');

    % -------------
    % Save into GIF
    drawnow
    frame_traj = getframe(f_GIF);
%     frame_traj = getframe(f_cameraTrajectory);
    img_traj   = frame2im(frame_traj);
    [imind_traj,cm] = rgb2ind(img_traj,256);
    if frameCount == range(1)
        imwrite(imind_traj,cm,filename_GIF_traj,'gif', 'Loopcount',inf, 'DelayTime',0.25); 
    else 
        imwrite(imind_traj,cm,filename_GIF_traj,'gif','WriteMode','append','DelayTime',0.25); 
    end 
end
end

