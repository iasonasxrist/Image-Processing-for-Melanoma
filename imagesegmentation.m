tic
clc;  close all; clear; 
format long g;
format compact;
fontSize = 16;

%Tottaly Asymmetric
baseFileName = '1.jpg';
%FULL PATH
folder = []; 
fullFileName = fullfile(folder, baseFileName);

% READ AND PREPROCESSING WITH MEDIAN FILTER
[grayImage,gray1] = preprocess_mole(baseFileName);
 
[rows, columns, numberOfColorChannels] = size(grayImage);
% ========================================================================

% % Get the dimensions of the image.
% % numberOfColorChannels should be = 1 for a gray scale image, and 3 for an RGB color image.
% [rows, columns, numberOfColorChannels] = size(grayImage)
% 
% 
% if numberOfColorChannels > 1
%     
%   % It's not really gray scale like we expected - it's color.
%   
%   grayImage = rgb2gray(grayImage);
%   
%   % ALTERNATE METHOD: Convert it to gray scale by taking only the green channel,
%   % which in a typical snapshot will be the least noisy channel.
%   % grayImage = grayImage(:, :, 2); % Take green channel.
%   
% end
% ========================================================================


% DISPLAY THE IMAGE
subplot(3, 3, 1);
imshow(grayImage, []);
axis on;
axis image;

caption = sprintf('Original Gray Scale Image');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;
hp = impixelinfo();

% SET UP FIGURE PROPERTIES

% Enlarge figure to full screen.
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);

% Get rid of tool bar and pulldown menus that are along top of figure.
%set(gcf, 'Toolbar', 'none', 'Menu', 'none');
% Give a name to the title bar.
% set(gcf, 'Name', 'Designed by IasonasXrist', 'NumberTitle', 'Off')
% drawnow;

% DISPLAY THE HISTOGRAM.
[pixelCount, grayLevels] = imhist(grayImage);
subplot(3, 3, 2); 
bar(grayLevels, pixelCount); % Plot it as a bar chart.
grid on;
title('Histogram of original image', 'FontSize', fontSize, 'Interpreter', 'None');
xlabel('Gray Level', 'FontSize', fontSize);
ylabel('Pixel Count', 'FontSize', fontSize);
xlim([0 size(grayLevels,1)]); % Scale x axis manually.

% =========================================================================
% Binarize the image by thresholding.
%Option 1
% mask = grayImage < 125;
% =========================================================================

%Option 2
I = graythresh(grayImage);
I=I*255;
mask = grayImage<I;

% Display the mask image.
subplot(3, 3, 3);
imshow(mask);
axis on;
axis image; 
title('Binary Image Mask', 'fontSize', fontSize);
drawnow;


% Get rid of blobs touching the border.
mask = imclearborder(mask);
% Extract just the largest blob.
mask = bwareafilt(mask,1);


% Get rid of black islands (holes) in struts without filling large black areas.
subplot(3, 3, 4);
mask = ~bwareaopen(~mask, 1000);
imshow(mask);
axis on;
axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.
title('Final Cleaned Mask', 'FontSize', fontSize);
drawnow;

%First , calculate the centroid and rotate the image into the major axis
%After that find the asymmetry 

% Find the coordinates of centroid
props = regionprops(mask, 'Centroid', 'Orientation');
xCentroid = props.Centroid(1);
yCentroid = props.Centroid(2);

middlex = columns/2;
middley = rows/2;
hold on;

line([middlex, middlex], [1, rows], 'Color', 'r', 'LineWidth', 2);
line([1, columns], [middley, middley], 'Color', 'y', 'LineWidth', 2);

plot(xCentroid, yCentroid, 'r+', 'MarkerSize', 30);
plot(xCentroid, yCentroid, 'ro', 'MarkerSize', 30);

% Translate the image(Shift the image by delatx and deltay to reach the centre of image)
%X coordinate diverges more than Y coordinate
deltax = middlex - xCentroid;
deltay = middley - yCentroid;
binaryImage = imtranslate(mask,  [deltax, deltay]);

% Display the image.
subplot(3, 3, 5);
imshow(binaryImage);
axis on;
title('Binary Image Translated to Middle', 'FontSize', fontSize);
% Plot a + at the center of the blob and center of the image.
hold on;
line([middlex, middlex], [1, rows], 'Color', 'b', 'LineWidth', 2);
line([1, columns], [middley, middley], 'Color', 'y', 'LineWidth', 2);
drawnow;

% Rotate the image to major axis
angle = -props.Orientation;
rotatedImage = imrotate(mask, angle, 'crop');


% Display the image.
subplot(3, 3, 6);
imshow(rotatedImage);
axis on;
caption = sprintf('Image Rotated by %f Degrees', angle);
title(caption,'fontSize',fontSize);
% Plot a + at the center of the blob and center of the image.
hold on;
line([middlex, middlex], [1, rows], 'Color', 'b', 'LineWidth', 2);
line([1, columns], [middley, middley], 'Color', 'y', 'LineWidth', 2);
drawnow;

%Asymmetry
[Asaxis,Asymmetry]  = asymmetry(binaryImage,rows,columns);
  fprintf('Asymmetry is : %f %% \n',Asaxis);
  A=Asaxis;
% flipped = fliplr(rotatedImage);
% overlapped = flipped & rotatedImage;
% nonOverlapped = xor(flipped, rotatedImage);
% diffImage= xor( flipped, binaryImage);
% figure();
% imshow(diffImage);

subplot(3,1,3);
borders = findBorders(rotatedImage);
imshow(borders);

% Circularity Index
chulls = bwconvhull(binaryImage);
stats = regionprops(chulls,'Area','MajorAxisLength','MinorAxisLength','EquivDiameter','BoundingBox','Perimeter');

% delta_sq = diff(binaryImage).^2;
% perimeter = sum(sqrt(sum(delta_sq,2)));
% area_metric = 4*pi*area/perimeter^2;
area = stats.Area;
Perimeter = stats.Perimeter;
area_metric2 = 4*pi*area/Perimeter^2;
fprintf("Circularity Index: %.2f\n",area_metric2);


MAL = stats.MajorAxisLength;
MIL = stats.MinorAxisLength;
bb  = stats.BoundingBox;
allBB= bb(3:4:end) .* bb(4:4:end);

 
 figure(2);
%BORDER IRREGULARITIES
%8-points Segmentation Connectivity for the detection of irregularity border
%  Option 1

dip = findborders1(rotatedImage);
BI = input("Set the number of irregularities(0-8):");

%   Option 2

% [x,BI]= compactness(Perimeter,area);
% fprintf("Compactness Index: %.2f\n",BI);
%   Option 3
%  Irregularity_Index_A = Perimeter/area;
%  Irregularity_Index_B = Perimeter/MAL;
%  Irregularity_Index_C = (Perimeter*(1/MIL-1/MAL));
%  Irregularity_Index_D = MAL-MIL;
%  
%  Irreg=[Irregularity_Index_A, Irregularity_Index_B, Irregularity_Index_C , Irregularity_Index_D ];
 

 %COLOR VARIATION
% color = [white;red;lightbrown;darkbrown;bluegray;black];
%   Option 1
%  counts = colourdetection(baseFileName);

%   Option 2
 color =  colorcalc(baseFileName);


 %DIAMETER
 dpi=96;
 [f,DMscore] = diameter_mole(MAL,dpi);
 fprintf("Diameter is %.1f mm\n",f);
toc

%FINAL CALCS

B=BI;
C=color; 
D=DMscore;
 
TDS = A*1.3 + B*0.1 + C*0.5 + D*0.5;
TDS
if (TDS>=1) && (TDS<=4.75)
    fprintf("Prediction :Benign\n");
elseif (TDS>4.75) && (TDS<=5.45)
    fprintf("Prediction: Suspicious\n");
elseif (TDS>=5.45)
    fprintf("Prediction: Malignant\n");
end
    
TDSIndex = [A,B,C,D]