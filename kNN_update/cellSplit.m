function chuckCell = cellSplit(ce,  l)
% split each element in the chuckCell cell into l part
%
% pass by reference here is better

ce_n = size(ce, 2);
array = cell2mat(ce);
chuckCell = arraySplit(array, l*ce_n);

%chuckCell = {};
%len_ce = length(ce);

%tmp = cell(1, ce_n);
%tmp(:) = {zeros(len_c)};

%for i = 1 : ce_n
%  % tmp{i} =  arraySplit(ce{i}, l);
%  lenc = length(ce{i});
%  s = ceil(lenc/l);
%  tmp{i} = mat2cell(ce{i}, 1, [repmat(s, 1, (l-1)), lenc-s*(l-1)]); 
%end
%chuckCell = flattenCell(tmp);



