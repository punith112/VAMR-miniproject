function [f_keypointScores,f_cameraTrajectory,cam,trajectory,trajectoryBA,landmarksScatter,landmarksHistoryScatter,landmarksScatterBA] = initializeFigures(location_initial,orientation_inital,X_initial)
%INITIALIZEFIGURES Summary of this function goes here
%   Detailed explanation goes here
%% Intialize plots
% plot of inlier and outlier keypoints on current images
% plot of RANSAC inlier share among all tracked keypoints
f_keypointScores = figure('Name','Share of Inliers');
    set(gcf, 'Position', [800, 50, 250, 250])
    subplot(2,1,1);
        xlabel('frame count');ylabel('share of inliers');
        title('Share of Inlier Keypoints');
    subplot(2,1,2);
        xlabel('frame count');ylabel('number keypoint');
        title('Number of tracked Keypoints');
% plot inital camera pose and landmarks
f_cameraTrajectory = figure('Name','3D camera trajectory');
    % set window position and size [left bottom width height]
    set(gcf, 'Position', [0, 200, 700, 600])
    axis equal
    %xlim([-20,20]); ylim([-10,20]); zlim([-5,35]);
    % set viewpoint
    view(0, 0);
    set(gca, 'CameraUpVector', [0, 0, 1]);
    xlabel('x-axis, in meters');ylabel('y-axis, in meters');zlabel('z-axis, in meters'); 
    grid on
    % initialize plot camera
    hold on
    cameraSize = 0.6;
    cam = plotCamera('Size', cameraSize, 'Location',location_initial, ...
        'Label','Current Pose', 'Orientation', orientation_inital,'Color', 'r', 'Opacity', 0.5);
    % initialize plot cam trajectory
    trajectory = plot3(0, 0, 0, 'r-','LineWidth',2);      
    title('Camera Trajectory and Triangulated Landmarks');
    % intialize plot 3D landmarks
    landmarksScatter = scatter3([], [], [], 5, 'o','b'); grid on;
    landmarksHistoryScatter = scatter3([], [], [], 2, 'o','k','MarkerEdgeAlpha',0.2); 
    grid on;
    legend('Trajectory','Landmarks', 'Landmarks History');
    legend('AutoUpdate','off');
    
    landmarksScatterBA = scatter3([], [], [], 5, 'o','g'); grid on
    trajectoryBA = plot3(0, 0, 0, 'g-','LineWidth',2);
%     legend('Trajectory', '?','landmarksScatter', 'landmarksHistoryScatter',...
%             'landmarksScatterBA');

end

