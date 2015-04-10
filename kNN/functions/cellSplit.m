function chuckCell = cellSplit(ce,  l)
% split each element in the chuckCell cell into l part
%
% pass by reference here is better

%chuckCell = {};
%len_ce = length(ce);
ce_n = size(ce, 2);
% --
tmp = cell(1, ce_n);
%tmp(:) = {zeros(len_c)};
%

for i = 1 : ce_n
    tmp{i} =  arraySplit(ce{i}, l);
end

chuckCell = flattenCell(tmp);
