function chuckCell = arraySplit(v, l)
% Split a array v into number of l chunks (substrings) of the same size if possible
% In not possible, the chunks are almost of equal size
%

% make sure the length(v) >= l
if length(v) < l,
      error('The number of elements in the array should be larger than chunk number');
end

%chuckCell = {};
chuckCell = cell(1, l);
%
split_size = 1/l * (numel(v));   

for i = 1 : l
    idx = [floor(round((i-1) * split_size)) : floor(round((i) * split_size)) - 1] + 1;
    chuckCell{i} = v(idx);
end


