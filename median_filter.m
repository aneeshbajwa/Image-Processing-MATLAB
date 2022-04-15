function imagefinal = median_filter(image,n)
% I-> image matrix
% n-> size of window nxn
% imagefinal -> final image returnd after filtering
% first step is to make size of matrix such that it can be converted into
% nxn smaller matrices
[rows,cols] = size(image);
r0 = mod(rows,n);
c0 = mod(cols,n);
r = rows + (n-r0);
c = cols + (n-c0);
I = uint8(zeros(r,c));
I(1:rows, 1:cols) = image;
%convert into subimages of size nxn
imgaefinal = zeros(r,c);
for i = 1:r/n
    for j = 1:c/n
        subim = sort(I((n*(i-1))+1:n*i, (n*(j-1))+1:n*j));
        if(mod(n,2)==0)
            w = (subim(n/2,n)+subim((n/2+1),1))/2;
            subim = repmat(w,n,n);
        else
            w = subim(ceil(n/2),ceil(n/2));
            subim = repmat(w,n,n);
        end
        imagefinal((n*(i-1))+1:n*i, (n*(j-1))+1:n*j) = subim;
    end
end
end