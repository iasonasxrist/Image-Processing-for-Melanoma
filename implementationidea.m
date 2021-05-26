    clc
         clear all
        myFolder='/Users/iasonasxrist/Documents/MATLAB/MelanomaDataset'
         m=input('Type the Number of Images to Process:');
         for k = 1:m
          jpgFilename = sprintf('%d.jpg', k);
          fullFileName = fullfile(myFolder, jpgFilename);
        %  end
          grayImage = imread(fullFileName);
        % Get the dimensions of the image.  numberOfColorBands should be = 1.
          [rows columns numberOfColorBands] = size(grayImage);
    if numberOfColorBands==3
          grayImage=rgb2gray(grayImage);
      else
           grayImage=grayImage;
      end
         % Display the original image.
        figure('name','grayImage','numbertitle','off');imshow(grayImage);
        fontSize=10
        % Enlarge figure to full screen.
         % Generate a noisy image with salt and pepper noise.
          noisyImage = imnoise(grayImage,'salt & pepper', 0.05);
          figure('name','noisyImage','numbertitle','off');imshow(noisyImage);
        % Median Filter the image:
        medianFilteredImage = medfilt2(noisyImage, [3 3]);
        % Find the noise.  It will have a gray level of either 0 or 255.
        noiseImage = (noisyImage == 0 | noisyImage == 255);
        % Get rid of the noise by replacing with median.
        noiseFreeImage = noisyImage; % Initialize
        noiseFreeImage(noiseImage) = medianFilteredImage(noiseImage); % Replace.
        % Display the image.
        figure('name','Restored Image','numbertitle','off');imshow(noiseFreeImage);
        % figure,imshow(noiseFreeImage);
        % title('Restored Image', 'FontSize', fontSize);
         end