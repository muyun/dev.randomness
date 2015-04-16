function chuckCell = arraySplit(v, l)
% Split a array v into number of l chunks (substrings) of the same size if possible
% In not possible, the chunks are almost of equal size
%

len = length(v);
%if len < l,
%    error('The number of elements in the array should be larger than chunk number');
%end

s = ceil(len/l);

res = mod(len, s);
if res > 0
    dimDiv = [repmat(s, 1, floor(len/s)), res];   %Repeat copies of array
else
    dimDiv = [repmat(s, 1, floor(len/s))];
end
chuckCell = mat2cell(v, 1, dimDiv);    %Convert array to cell array with potentially different sized cells

 
%chuckCell = {};
%chuckCell = cell(1, l);
%
%split_size = 1/l * (numel(v));

%for i = 1 : l
%    idx = [floor(round((i-1) * split_size)) : floor(round((i) * split_size)) - 1] + 1;
%    chuckCell{i} = v(idx);
%end