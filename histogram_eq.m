function m = histogram_eq(I)
L = 256;
h = uint8(zeros(2,L));
h(1,:) = 0:L-1;
L = 256;
[rows,cols] = size(I);

% Preallocate H
H = uint32(zeros(2, L));
H(1, :) = 0 : (L-1);


% This for loop actually counts the number of occurrences of each 'i' by
% summing of all ones in the matrix img==i, where ones only occur where
% img(x,y)==i
for i = 0 : (L-1)
    H(2, i+1) = sum(sum( I==i ));
end 




% Convertes the histograminto relative frequencies (probabilities)
s = sum(H(2,:));
p = double(H(2,:)) / double(s);

% Preallocates the map matrix
% (note: only its second row will actually be used)
m = uint8(zeros(2, L));
m(1, :) = 0 : (L-1);

% sum of all probabilities between 0 and the current i
% (a.k.a cumulative distribution function)
cdf = 0;

% Obtains cdf for each pixel value and the new value it maps to
%
%             i
%           -----
%           \
%   cdf(i) = >    p(w)
%           /
%           -----
%            w=0
%
%
%   m(i) = cdf(i) * (L-1) 
%
for i = 0 : (L-1)
    cdf = cdf + p(i+1);
    m(2, i+1) = uint8( (L-1) * cdf );
end  % for i

end
