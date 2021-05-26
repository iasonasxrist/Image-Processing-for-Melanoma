function [Asaxis,Asymmetry] = asymmetry(binaryImage,rows,columns)

%If asymmetry< 1.5% then is symmetric
% Asymmetry = (areaDifference/lesionarea)*100;

% areaDif = abs(xaxis - yaxis);
% Asymmetry_2 = (areaDif/allArea)*100;
% Asymmetry = asymmetry_correction(binaryImage);

topArea = sum(sum(binaryImage(1:rows/2,:)));
bottomArea = sum(sum(binaryImage(rows/2+1:end,:)));
areaDifference = abs(topArea - bottomArea);
lesionarea = topArea+bottomArea;

Asymmetry = (areaDifference/lesionarea)*100;

if Asymmetry>=1.5
    disp("Examinate the mole about symmetry");
    disp("Instructions:");
    disp("A=1: If mole is asymmetrical in 1-axis");
    disp("A=2: If mole is asymmetrical in 2-axis");
    Asaxis=input("Enter asymmetry index:");
elseif Asymmetry<1.5
    Asaxis=0;
    
end
Asaxis;
Asymmetry;

  