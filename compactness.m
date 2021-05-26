function [x,BI] = compactness(area,perimeter)
x=((perimeter^2)/(4*pi*area));
BI=x;