function [paramsInitialization,paramsContinuous] = loadKittiParams()
%LOADKITTIPARAMS Summary of this function goes here
%   Detailed explanation goes here

% initialization parameters KITTI
paramsInitialization = struct (...
...% Harris detection parameters
'MinQuality', 30e-5, ...               
'FilterSize', 11, ...
... % Ransac fundamental matrix parameters
'NumTrials', 3000, ...              
'DistanceThreshold', 0.2, ...
... % KLT tracking parameters
'BlockSizeKLT',[21 21], ...            
'MaxIterations',30, ...         
'NumPyramidLevels',4, ...
'MaxBidirectionalError',1 ...  
);

% processFrame parameters KITTI
paramsContinuous = struct (...
... % KLT parameters
'BlockSize',[15 15], ...            
'MaxIterations',17, ...         
'NumPyramidLevels',3, ...
'MaxBidirectionalError',1,...
... % P3P parameters 
'MaxNumTrialsPnP',1600, ...            
'ConfidencePnP',60,...
'MaxReprojectionErrorPnP', 2, ...
... % Triangulation parameters
'AlphaThreshold', 6 *pi/180, ...   %Min baseline angle [rad] for new landmark (alpha(c) in pdf)
... % Harris paramters for canditate keypoint exraction
'MinQuality', 15e-5, ... % higher => less keypoints
'FilterSize', 21, ...
... % Matching parameters for duplicate keypoint removal
'BlockSizeHarris', 11, ... % feature extraction parameters
'MaxRatio', 1.00,... % higehr => more matches
'MatchThreshold', 100.0,...  % higher  => more matches  
'Unique', false, ...
... % Minimum pixel distance between new candidates and existing keypoints
'MinDistance', 11 ...
);
end

