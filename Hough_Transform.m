I = imread('cap.jpeg');
%rotI = imrotate(I,33,'crop');
rotI = im2gray(I);
%detecting edges bby looking for local maxima of gradient values
BW = edge(rotI,'canny');

% find the hough transform of thee image 
% H - Hough transform matrix - size nrho - ntheta
% T - theta
% R - rho
[H,T,R] = hough(BW);
imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;

% find peaks in hough transform
% H - Hough transform matrix
% 5 - no of peaks
% threshold = ceil(0.3*max(H(:))) - minimum value to be considered a peak
% P - matrix that holds the row and column coordinates of the peaks
P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x = T(P(:,2)); % transpose of colum coordinates of the maximas 
y = R(P(:,1)); % row coordinates of the maximas
plot(x,y,'s','color','white');

%Find lines and plot them
%hough lines eturn value lines contains information about the extracted line segments
% FillGap - Distance between two line segments associated with the same Hough 
%transform bin, specified as a positive number. When the distance between 
%the line segments is less than the value specified, the houghlines function 
%merges the line segments into a single line segment.
% MinLength - Minimum line length, specified as a positive number. 
%houghlines discards lines that are shorter than the value specified.

lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',7);
figure(2) ;
imshow(rotI),hold on;
max_len = 0;


for k = 1:length(lines)
    
    % Selecting lines one by one
    xy = [lines(k).point1; lines(k).point2];
    
    % Plotting lines on the figure of circuit
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    
    %plot ends and beginings of lines
    % marking end with cross 'x' 
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
    
    %determine the endpoints of the longest line segment
    len = norm(lines(k).point1 - lines(k).point2);
    if( len > max_len)
        max_len = len;
        xy_long = xy;
    end
end


%changing colour of the longest line  segment from greeen to magenta
plot(xy_long(:,1) , xy_long(:,2), 'LineWidth', 2, 'Color', 'magenta');
