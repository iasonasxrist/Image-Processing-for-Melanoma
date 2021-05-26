function  color = colorcalc(baseFileName);
% baseFileName = '550952.jpg';
rgbImage = imread(baseFileName);
rgbImage = im2double(rgbImage);

% Light_Brown=[0.80,0.52,0.25];
% Dark Brown=[0.40,0.26,0.13];
% Blue_gray = [0.0,0.52,0.54 ];
% red_orange =[1.0,0.0,0.0 ];
% black =[0,0,0];
% white = [1,0.95,1];
%COLOR VALUES
r1=1;b1=0.95;g1=1;r2=0.0;b2=0.0;g2=0.0;r3=0.80;b3=0.52;g3=0.25;
r4=0.40;b4=0.26;g4=0.13;r5=1.0;b5=0.0;g5=0.0;r6=1.0;b6=0.52;g6=0.54;



[rows,columns,numberOfColorBands] = size(rgbImage);
% subplot(3, 4, 1);

% imshow(rgbImage,[]);
% title('Color Image', 'FontSize', fontSize);
r = rgbImage(:,:,1);
g = rgbImage(:,:,2);
b = rgbImage(:,:,3);

Dwhite =0;Dblack=0;Dlight_brown=0;Ddark_brown=0;Dred_orange =0;Dblue_gray=0;

for i=1:rows
    for j=1:columns
Dwhite = Dwhite +   sqrt((r(i,j)-r1)^2 + (g(i,j)-g1)^2 + (b(i,j)-b1)^2) ;
Dblack = Dblack  +  sqrt((r(i,j)-r2)^2 + (g(i,j)-g2)^2 + (b(i,j)-b2)^2) ;
Dlight_brown =Dlight_brown + sqrt((r(i,j)-r3)^2 + (g(i,j)-g3)^2 + (b(i,j)-b3)^2);
Ddark_brown =Ddark_brown   + sqrt((r(i,j)-r4)^2 + (g(i,j)-g4)^2 + (b(i,j)-b4)^2) ;
Dred_orange = Dred_orange  + sqrt((r(i,j)-r5)^2 + (g(i,j)-g5)^2 + (b(i,j)-b5)^2) ;
Dblue_gray = Dblue_gray    + sqrt((r(i,j)-r6)^2 + (g(i,j)-g6)^2 + (b(i,j)-b6)^2) ;
    end
end

Dwhite = Dwhite/(size(rgbImage,1)*size(rgbImage,2));
Dblack = Dblack/(size(rgbImage,1)*size(rgbImage,2));
Dlight_brown = Dlight_brown/(size(rgbImage,1)*size(rgbImage,2));
Ddark_brown =  Ddark_brown/(size(rgbImage,1)*size(rgbImage,2));
Dred_orange =  Dred_orange/(size(rgbImage,1)*size(rgbImage,2));
Dblue_gray =   Dblue_gray/(size(rgbImage,1)*size(rgbImage,2));

% D<T ,T=0.4
T=0.4;
color = zeros(1,6);
% Light_Brown=0;
% Black=0;
% Dark_Brown=0;
% red_orange=0;
% Blue_gray=0;
% white=0;
  color = [Dwhite;Dred_orange;Dlight_brown;Ddark_brown; Dblue_gray;Dblack];


if Dwhite>T
   color(1)= 1;
else 
    color(1)=0;
end
    if Dred_orange>T
        color(2)= 1;
    else
        color(2)=0;
    end
        if  Dlight_brown>T
            color(3)= 1;
        else
            color(3)=0;
        end
        
            if Ddark_brown>T
                color(4) = 1;  
            else
                color(4)=0;
            end
            
                if Dblue_gray>T
                    color(5)=1;
                else
                     color(5)=0;
                end
                
                    if Dblack>T
                          color(6)=1;
                    else 
                        color(6)=0;
                    end
      
   color = sum(color)
