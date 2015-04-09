function y = flattenCell(x)
% flatten a cell array tree structure into a single cell array
%
% INPUT:
%              x = flatten({[1,0],[1]}, {[1,1], [0,1]})
% 
% OUTPUT:
%             y = 
%                     { [1,0]    [1]    [1,1]    [0,1]} 
%
%  some code borrows from flatten.m
%
if ~iscell(x)
     error('flatten only works on cell arrays.');
end

y = inner_flatten(x);

function y = inner_flatten(x)
        if  ~iscell(x),
              y = {x};
              
        else
              y = {};
              
             for n = 1:numel(x)  % numel() returns the number of elements in cell x
                 % for each element
                 % get the non-cell structure and store it in y
                  tmp = inner_flatten(x{n});
                  
                  y = {y{:}  tmp{:}};
             end
    
end