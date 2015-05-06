function chuckCell = cellSplit(ce,  l)
% split each element in the chuckCell cell into l part
%
% pass by reference here is better

ce_n = size(ce, 2);
array = cell2mat(ce);
chuckCell = arraySplit(array, l*ce_n);



