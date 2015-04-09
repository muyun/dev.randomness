function d = binaryVectorToDecimal(b)
% Convert binary vector value to decimal value
%

% some code borrows from bi2de.m

inType = class(b);
b = double(b);   % to allow non-doubles to work

n = size(b, 2);
b2 = b;
b = b2(: ,  n:-1:1);

%n =sum(p.*(2.^[length(p)-1 : -1 : 0]));  %multiply each element by the binary value, then sum
max_length = 1024;
pow2vector = 2.^(0:1:(size(b,2)-1));
size_B = min(max_length,size(b,2));
d = b(:,1:size_B)*pow2vector(:,1:size_B).';

% handle the infs...
idx = find(max(b(:,max_length+1:size(b,2)).') == 1);
d(idx) = inf;

d = feval(inType, d);
d = d';
