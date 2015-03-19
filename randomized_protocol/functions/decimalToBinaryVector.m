function b = decimalToBinaryVector(d)
% Convert each decimal value in s to binary vector
%
%  some code borrows from de2bi.m

inType = class(d);
d = double(d(:));
len_d = length(d);

len_col = floor( log(max(d)) / log(2)) + 1;

b = zeros(len_d, len_col ); 

%      m(i) = bitget( s(i), fix( log2(s(i)) ) + 1:-1:1);   

[f, e]=log2(max(d)); % How many digits do we need to represent the numbers?
 b=rem(floor(d*pow2( 1 - max(len_col, e) : 0)), 2);
 
 b = feval(inType, b);
