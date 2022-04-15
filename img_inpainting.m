function [it] = img_inpainting(I)
% input -> I = 2D image matrix
% ouput -> it = dI/dt = grad(Lap(I)).grad(I)^p for each pixel in I
[rows,cols] = size(I);

%                       0  1 0
% Laplacian operator =  1 -4 1
%                       0  1 0
Lap = [0 1 0 ; 1 -4 1 ; 0 1 0];

%perform laplacian on img
LI = conv2(double(I),Lap,'same');

%pre locate img as zeros matrix of same size of I
it = zeros(rows,cols);

%Iterate through each pixel of I and find gradiant of I and LI

for x = 1:rows
    for y = 1:cols
        
        % gradL will store gradiant of laplacian
        gradL = [0;0];
        % gradI will store gradiant of image
        gradI = [0;0];
        
        if x>1 && x<rows
            % mask of gradiant in x dir = [-1 0 1]
            gradL = (LI(x+1,y)-LI(x-1,y))/2;
            gradI = (double(I(x+1,y)) - double(I(x-1,y)))/2;
        elseif x==1
            % mask = [-1 1]
            gradL = (LI(x+1,y)-LI(x,y))/2;
            gradI = (double(I(x+1,y)) - double(I(x,y)))/2;
            
        else %x==rows
            %mask = [-1 1]
            gradL = (LI(x,y)-LI(x-1,y))/2;
            gradI = (double(I(x,y)) - double(I(x-1,y)))/2;
        end
        % Now we need to take perpendicular of gradI which could be
        % obtained by setting any compenent equal to its -ve
        gradI(1) = -gradI(1);
        
        %it = dI/dt = grad(Lap(I)).grad(I)^p for each pixel in I
        
        it(x,y) = gradL * gradI;
        
    end
end

end