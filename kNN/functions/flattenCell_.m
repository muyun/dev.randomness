function c = flattenCell_(a)
% Linearize a cell array tree structure into a array
%
% INPUT:
%              a = flatten({[1,0],[1]}, {[1,1], [0,1]})
% 
% OUTPUT:
%             c = 
%                      [1,0]    [1]    [1,1]    [0,1] 
%
%  some code borrows from flatten.m
%
if ~iscell(a),
     error('flatten only works on cell arrays.');
end

c = {};

for i=1:numel(a)   % numel() returns the number of elements
        if  ~iscell(a{i}),
               c = [c, a{i}];

        else
               tmp = flatten_(a{i});
               c = [c, tmp{:}];
        end
end