 function [medianFilteredImage,gray1] = preprocess_mole(baseFileName)

workspace;
fontSize = 14;
folder = [];

% baseFileName = '21821.jpg';
% Get the full filename, with path prepended.
fullFileName = fullfile(folder, baseFileName);


rgbImage = imread(baseFileName);
%RESIZE
% rgbImage = imresize(rgbImage,[400 400]);

%  rgbImage = imresize(rgbImage,[600 600]);
% Get the dimensions of the image.  numberOfColorBands should be = 3.

[rows, columns, numberOfColorBands] = size(rgbImage);

if numberOfColorBands >1
   grayimage = rgb2gray(rgbImage);
else 
    grayimage = rgbImage;
end

% Display the original color image.
figure(1);
subplot(3, 3, 1);
imshow(rgbImage, []);

subplot(3,3,2);
 imshow(grayimage,[]);

medianFilteredImage = medfilt2(grayimage, 'indexed',[3 3]);

subplot(3,3,3);
imshow(medianFilteredImage,[]);

gray1 = grayimage;
medianFilteredImage;
