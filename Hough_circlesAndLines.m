function[Hc,Cx,Cy,r, Hs ,t , rho] = Hough_circlesAndLines(I)
% Implementation Of hough transform for circles and lines
% I -> binary image 
% Hc -> 3D hough transform matrix for cicles
% Cx -> x co - ordinate of centre
% Cy -> y co - ordinate of centre
% R -> radius of circle
% Hs -> 2d hough transfrom matrix for straight lines
% t -> theta angle between the x axis and perpendicular from centre to line
% rho -> perpendicular distance of straight line from centre
[rows,cols] = size(I);

%ranges for each parametes - Cx, Cy, r
% given that each pixel represents a point on graph
Cx = 1 : rows;
Cy = 1 : cols;
r = 1:min(rows,cols);

%prelocate Hc -> the hough matrix
Hc = zeros(rows, cols, length(r));

% Now increement the discreetized boxes in H matrix for each possible
% combination of Cx, Cy and r
for X = 1 : length(Cx)
    x0 = Cx(X);
    for Y = 1:length(Cy)
        y0 = Cy(Y);
        for Radius = 1:length(r)
            rad = r(Radius);
            % (x-x0)^2 + (y-y0)^2 = rad^2
            % for different values of x find y
            %  x0 - rad < x < x0 + rad
            for x = max(x0 - rad,1) : min(x0 + rad,rows)
                % as x values should lie inside the image for a full circle
                % a = y - y0 or -a = y - y0
                a = sqrt(rad^2 - (x - x0)^2);
                % for both possibilities
                y1 = y0 + a;
                y2 = y0 - a;
                % check if y1 & y2 are within image range and then vote for
                % them in H matrix
                if (y1<= cols && 1==I(uint16(x), uint16(y1)))
                    
                    Hc(x0,y0,rad) = Hc(x0,y0,rad)+1;
                end
                if (y2>=1 && 1==I(uint16(x), uint16(y2)))
                    Hc(x0,y0,rad) = Hc(x0,y0,rad)+1;
                end
        end
    end
end

% Now for straight line
% ranges for theta and rho
t = 0 : 360;
rho = 1 : floor(sqrt(rows^2 + cols^2));

%prelocate hs
Hs = zeros(length(rho),length(t));

%Now for each point on image
for x = 1:rows
    for y = 1:cols
        if(1 == I(uint16(x), uint16(y)))
            for theta = 1:length(t)
                %Now for each value of theta for this set of x & y find rho 
                % and increment in the H matrix
                % rho = xcos(theta) + ysin(theta)
                p = abs(x*cos(theta*pi/180) + y*sin(theta*pi/180));
                if(1<=p<=length(rho)-1 )
                    Hs(ceil(p),theta) = Hs(ceil(p)+1,theta)+1;
                end
            end
        end
    end
end 
end