 % # ***************************************************************************
% #   Stereo Vision - Thermal 
% #   ---------------------------------
% #   Written by: Lakitha Omal Harindha Wijeratne
% #   - for -
% #   Mints: Multi-scale Integrated Sensing and Simulation
% #   ---------------------------------
% #   Date: March 29th, 2020
% #   ---------------------------------
% #   This module is written for generic implimentation of MINTS projects
% #   --------------------------------------------------------------------------
% #   https://github.com/mi3nts
% #   http://utdmints.info/
% #  ***************************************************************************

%% Section_002 : Generating Thermal Camera Calibration Parametors

% For the thermal camera calibration utdset4 is used

% Define images to process
%-------------------------------------------------------
clc 
close all
clear all

% Define images to process
imageFileNames = {...
    '/home/teamlary/mintsData/jetson001Set000/thermal/2020_03_29_19_54_05_528377_thermal.jpg',...
    '/home/teamlary/mintsData/jetson001Set000/thermal/2020_03_29_19_55_01_670386_thermal.jpg',...
    '/home/teamlary/mintsData/jetson001Set000/thermal/2020_03_29_19_55_05_660695_thermal.jpg',...
    '/home/teamlary/mintsData/jetson001Set000/thermal/2020_03_29_19_55_13_711706_thermal.jpg',...
    '/home/teamlary/mintsData/jetson001Set000/thermal/2020_03_29_19_55_16_502056_thermal.jpg',...
    '/home/teamlary/mintsData/jetson001Set000/thermal/2020_03_29_19_55_18_990423_thermal.jpg',...
    '/home/teamlary/mintsData/jetson001Set000/thermal/2020_03_29_19_55_23_142074_thermal.jpg',...
    '/home/teamlary/mintsData/jetson001Set000/thermal/2020_03_29_19_55_26_485430_thermal.jpg',...
    '/home/teamlary/mintsData/jetson001Set000/thermal/2020_03_29_19_55_27_855261_thermal.jpg',...
    '/home/teamlary/mintsData/jetson001Set000/thermal/2020_03_29_20_09_16_825987_thermal.jpg',...
    '/home/teamlary/mintsData/jetson001Set000/thermal/2020_03_29_20_09_18_378426_thermal.jpg',...
    '/home/teamlary/mintsData/jetson001Set000/thermal/2020_03_29_20_09_37_704568_thermal.jpg',...
    '/home/teamlary/mintsData/jetson001Set000/thermal/2020_03_29_20_09_43_036819_thermal.jpg',...
    '/home/teamlary/mintsData/jetson001Set000/thermal/2020_03_29_20_10_41_166160_thermal.jpg',...
    '/home/teamlary/mintsData/jetson001Set000/thermal/2020_03_29_20_21_59_047399_thermal.jpg',...
    '/home/teamlary/mintsData/jetson001Set000/thermal/2020_03_29_20_22_02_546010_thermal.jpg',...
    '/home/teamlary/mintsData/jetson001Set000/thermal/2020_03_29_20_22_25_782159_thermal.jpg',...
    '/home/teamlary/mintsData/jetson001Set000/thermal/2020_03_29_20_22_34_313166_thermal.jpg',...
    '/home/teamlary/mintsData/jetson001Set000/thermal/2020_03_29_20_22_51_262015_thermal.jpg',...
    '/home/teamlary/mintsData/jetson001Set000/thermal/2020_03_29_20_23_05_505157_thermal.jpg',...
    '/home/teamlary/mintsData/jetson001Set000/thermal/2020_03_29_20_23_20_532294_thermal.jpg',...
    };

% Detect checkerboards in images
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Read the first image to obtain image size
originalImage = imread(imageFileNames{1});
[mrows, ncols, ~] = size(originalImage);

% Generate world coordinates of the corners of the squares
squareSize = 35;  % in units of 'millimeters'
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera
[thermalParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'millimeters', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
    'ImageSize', [mrows, ncols]);

% View reprojection errors
h1=figure; showReprojectionErrors(thermalParams);

% Visualize pattern locations
h2=figure; showExtrinsics(thermalParams, 'CameraCentric');

% Display parameter estimation errors
displayErrors(estimationErrors, thermalParams);

% For example, you can use the calibration data to remove effects of lens distortion.
undistortedImage = undistortImage(originalImage, thermalParams);

% See additional examples of how to use the calibration data.  At the prompt type:
% showdemo('MeasuringPlanarObjectsExample')
% showdemo('StructureFromMotionExample')



save('dataFiles/DF_003_thermalJetson001_2020_03_29')
save('dataFiles/DF_003_pythonThermalJetson001_2020_03_29',...
        'imageFileNames',...
        'imagePoints'...
        )
close all
