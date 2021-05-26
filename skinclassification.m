clc;  close all; clear; 
format long g;
format compact;
fontSize = 15;

%collect the images
S=dir("MelanomaDataset");

results = zeros(length(S),4);

baseFileName = '21821.jpg';
%Tottaly Asymmetric
% baseFileName = '550952.jpg';
%FULL PATH
folder = []; 
fullFileName = fullfile(folder, baseFileName);

%Preprocessing
 [grayImage,gray1] = preprocess_mole(baseFileName);
 
[rows, columns, numberOfColorChannels] = size(grayImage);

%Border Detection


%Feature Extraction

%ASYMMETRY

%BORDER IRERULLARITIES

%COLOR VARIATION

%
%Classification

%TDS = A x 1.3 + B x 0.1 + C x 0.5 + D x 0.5