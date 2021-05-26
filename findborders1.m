 function  iwant= findborders1(rotatedImage)

%Read rotated image
mask = rotatedImage;
% =============================================================
% mask=mask(41:616,128:894,1)>128;
% imshow(mask)
% %fill all holes:
% %flip mask and select everything that is not the outer area
% mask= bwlabel(~mask,4) ~= 1;
% imshow(mask)
%find the edge pixels with something like imerode
% ==============================================================
SE=true(3*ones(1,ndims(mask)));%structuring element
edge= mask & ~( mask & convn(mask,SE,'same')==sum(SE(:)) );

%%
%find the bounding box with 1 px margin
colind_first=find(sum(mask,1),1,'first')-1;
colind_last =find(sum(mask,1),1,'last')+1;
rowind_first=find(sum(mask,2),1,'first')-1;
rowind_last =find(sum(mask,2),1,'last')+1;
box=false(size(mask));
box([rowind_first rowind_last], colind_first:colind_last )=true;
box( rowind_first:rowind_last ,[colind_first colind_last])=true;

%add the diagonal lines to the box1:2
x=false(size(mask));
p=polyfit([rowind_first rowind_last],[colind_first colind_last],1);
row=rowind_first:rowind_last;
col=round(polyval(p,row));
x(sub2ind(size(x),row,col))=true;

%%
%add other diagonal to x
p=polyfit([rowind_first rowind_last],[colind_last colind_first],1);
col=round(polyval(p,row));
x(sub2ind(size(x),row,col))=true;

%%
dist2xbox=bwdist(box | x);
distance=dist2xbox(edge);


subplot(3,3,1);
imshow(edge | box | x);

subplot(3,3,2);
plot(distance)
I=imgaussfilt(distance,30);

subplot(3,3,3);
plot(I)
j=diff(I);

subplot(3,3,4);
plot(j);
z=1:length(distance);

n = 8 ; 
d=j';
a=length(j);
% check whether data needed to be appended to reshape into n 
b = n * ceil(a / n)-a ;
% 
d = [d NaN(1,b)] ;
iwant = reshape(d,[],n);
% plot 
subplot(3,3,5);
plot(iwant','b.')

subplot(3,3,6);
plot(rotatedImage);
hold on;

iwant = double(iwant);
K = size(iwant,1);
L = size(iwant,2);

want=zeros(K,L);
n=0;
for j=1:L
    for i=1:K
    if (iwant(i,j)>=0.5) | (iwant(i,j)<=-0.5)
       want(i,j)=iwant(i,j);
    end
    end 
end

subplot(3,3,7:9);
plot(want);


