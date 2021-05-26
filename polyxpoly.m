function [X loc t] = polyxpoly(P1, P2, magnet)
% function X = polyxpoly(P1, P2)
% Crossing points of two 2D polygons P1 and P2.
%
% INPUTS:
% P1 and P2 are two-row arrays, each column is a vertice
% They might or might not be wrapped around
% If the open is closed, user must make sure to wrap so that the
% first and the last points are identical
% [X loc t] = polyxpoly(..., magnet)
% is useful when polygon touching each other
% if magnet > 0, glue polygons,
% magnet < 0, detach polygons
% OUTPUTS:
% X is two-row array, each column is an crossing point
% loc: two-row array, which edges the crossing point belong?
% first row corresponds to P1, second row to P2
% edge#1 is P(:,[1 2]), edge#2 is P(:,[2 3]), ... etc
% t: floating parametric of the crossing point
%
% Author: Bruno Luong <brunoluong@yahoo.com>
% History:
% Original 20-May-2010
% 19-Jun-2010: 
% Change function name, remove the automatic wrapping, so that
% polyxpoly can operate on open polygons as well 
% 02-Feb-2011: return LOC and T

if nargin<3 || isempty(magnet)
    magnet = 0;
end

% Swap P1 P2 so that we loop on a smaller one (faster)
swap = size(P1,2) > size(P2,2);
if swap
    [P1 P2] = deal(P2, P1);
end

% Glue the 2 polygon together
if magnet ~= 0
    % Check if P1 count-clock-wise oriented
    ccw1 = carea(P1) > 0;
    dP = 0;
    % Loop over segments of P1
    for n=1:size(P1,2)-1
        dP = dP + magnetdisplacement(P1(:,n:n+1), P2);
    end
    if xor(ccw1, magnet)
        P2 = P2-dP; % pull
    else
        P2 = P2+dP; % push
    end
end

% We increment the intermediate results by this amount, modifiable
increment = 10;

% Empty buffer
X = zeros(2,0);
loc = zeros(2,0);
t = zeros(2,0);
filled = 0;
sizec = 0;
% Loop over segments of P1
for n=1:size(P1,2)-1
    [cn t1 t2 i2] = seg2poly(P1(:,n:n+1), P2);
    m = size(cn,2);
    filled = filled+m;
    % Buffer too small
    if sizec < filled
        sizec = filled+increment;
        X(2,sizec) = 0;
        loc(2,sizec) = 0;
        t(2,sizec) = 0;
    end
    % Store the result
    ifill = filled+(-m+1:0);
    X(:,ifill) = cn;
    loc(1,ifill) = n;
    loc(2,ifill) = i2; 
    t(1,ifill) = t1;
    t(2,ifill) = t2;
end

% remove the tails
X(:,filled+1:end) = [];
loc(:,filled+1:end) = [];
t(:,filled+1:end) = [];

if swap
    loc = loc([2 1],:);
    t = t([2 1],:);
end

% floating parameters of the crossing point
t = loc+t;

end % polyxpoly

%%
function [cross_X cross_t1 cross_t2 cross_i2] = seg2poly(s1, P)
% [cross_X cross_t1 cross_t2 cross_i2] = seg2poly(s1, P)
% Check if a line segment s1 intersects with a polygon P.
% INPUTS:
% s1 is (2 x 2) where
% s1(:,1) is the first point
% s1(:,2) is the the second point of the segment.
% P is (2 x n) array, each column is a vertices
% OUTPUT
% cross_X is (2 x m) array, each column is an intersecting point
% cross_t1: floating array of the parameter in s1 of the crossing points
% cross_t2: floating array of the parameter in P of the crossing points
% cross_i2: integer array: which edge of P crossing s1
%
% Author: Bruno Luong <brunoluong@yahoo.com>
% History:
% Original 20-May-2010
% 02-Feb-2011: return T1 T2

% Translate so that first point is origin
a = s1(:,1);
M = bsxfun(@minus, P, a);
b = s1(:,2)-a;
nb2 = b(1)^2+b(2)^2;
% Check if the points are on the left/right side
x = [b(2) -b(1)]*M; % 1 x n
sx = sign(x);
% x -coordinates has opposite signs
crossx = sx(1:end-1).*sx(2:end) <= 0;

%% Crossing point
ix = find(crossx);
% cross point to the y-axis (along the segment)
x1 = x(ix);
x2 = x(ix+1);
d = b.'/nb2;
y1 = d*M(:,ix);
y2 = d*M(:,ix+1);
dx = x2-x1;
t1 = (y1.*x2-y2.*x1)./dx;
% Check if the cross point is inside the segment
ind = t1>=0 & t1<1;
if any(ind)
    cross_t1 = t1(ind);
    cross_t2= -x1(ind)./dx(ind);
    cross_X = bsxfun(@plus, a, b*cross_t1);
    cross_i2 = ix(ind);
else
    cross_X = zeros(2,0);
    cross_t1 = zeros(1,0);
    cross_t2 = zeros(1,0);
    cross_i2 = [];
end

end % seg2poly

%%
function dP = magnetdisplacement(s1, P)
% function X = seg2poly(s1, P)
% Check if a line segment s1 intersects with a polygon P.
% INPUTS:
% s is (2 x 2) where
% s(:,1) is the first point
% s(:,2) is the the second point of the segment.
% P is (2 x n) array, each column is a vertices
% OUTPUT
% X is (2 x m) array, each column is an intersecting point
% t1: floating array of the parameter in s1 of the crossing points
% t2: floating array of the parameter in P of the crossing points
% i2: integer array: which edge of P crossing s1
%
% Author: Bruno Luong <brunoluong@yahoo.com>
% History:
% Original 20-May-2010
% 02-Feb-2011: return T1 T2

% Relative tolerance for alignement detection
tol = 2^(-16); % 1.5259e-005

% Translate so that first point is origin
a = s1(:,1);
M = bsxfun(@minus, P, a);
b = s1(:,2)-a;
nb2 = b(1)^2+b(2)^2;
x = [b(2) -b(1)]*M; % 1 x n

dP = zeros(size(P));

%% Aligned points
% Detect degenerated case where two segments are more or less aligned
ison = abs(x) < tol*sqrt(nb2);
% find successive pairs that aligned with s1
ion = strfind(ison,[true true]);
% cross point to the y-axis (along the segment)
d = b.'/nb2;
y1 = d*M(:,ion);
y2 = d*M(:,ion+1);
dy = y2-y1;
ymin = min(y1,y2);
ymax = max(y1,y2);
% Check [ymin,ymax] intersect [0 1]
ind = (dy~=0) & (ymax>=0 | ymin<=1);
ion = ion(ind);
ion = union(ion, ion+1);
movevector = tol*[-b(2); b(1)]; % minus axis
dP(:,ion) = repmat(movevector, [1 length(ion)]); 



end % seg2poly