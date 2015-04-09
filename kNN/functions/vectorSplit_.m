function chuckCell = vectorSplit(v, l)
% split a vector v into number of l chunks (substrings) of the same size if possible
% In not possible, the chunks are almost of equal size
%
chuckCell = {};

%
split_size = 1/l * (numel(v));   

for i = 1 : l
    idx = [floor(round((i-1) * split_size)) : floor(round((i) * split_size)) - 1] + 1;
    chuckCell{end + 1} = v(idx);
end


