function chuckCell = arraySplit(v, l)
% Split a array v into number of l chunks (substrings) of the same size if possible
% In not possible, the chunks are almost of equal size
%

len = length(v);
s = ceil(len/l);

res = mod(len, s);
if res > 0
    dimDiv = [repmat(s, 1, floor(len/s)), res];   %Repeat copies of array
else
    dimDiv = [repmat(s, 1, floor(len/s))];
end
chuckCell = mat2cell(v, 1, dimDiv);    %Convert array to cell array with potentially different sized cells