clc;clear;close all;

format long g;
format compact;
fontSize = 15;

baseFileName = '896.jpg';
folder=[];
fullFileName = fullfile(folder, baseFileName);

Image = im2double(imread(fullFileName));
subplot(3,1,1);
imshow(Image)

grayImage = rgb2gray(Image);
subplot(3,1,2);
imshow(grayImage)
%get hairs using bottomhat filter
se = strel(nhood);
hairs = imclose(grayImage,se);

I = graythresh(grayImage);
I=I*255;
hairs = hairs<I;

%%%%%%%%%
lab_mask = bwlabel(hairs);
%%%%%%%%
subplot(3,1,3);
imshow(lab_mask)

stats = regionprops(lab_mask, 'MajorAxisLength', 'MinorAxisLength'); 
mediatedImage = medfilt2(grayImage);
subtraction = double(grayImage) - double(mediatedImage);
imshow(subtraction)
%identifies long, thin objects 

Aaxis = [stats.MajorAxisLength]; 
Iaxis = [stats.MinorAxisLength]; 
idx = find((Aaxis ./ Iaxis) > 4); % Selects regions that meet logic check 
out_mask = ismember(lab_mask, idx);
figure, imshow(out_mask);

modifiedimage = roifill(grayImage, hairs);
figure, imshow(modifiedimage);





