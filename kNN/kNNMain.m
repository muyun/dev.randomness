clear, clc;
% kNN(q, k)
%
% recursion method is used here although there is a bit limition of matlab
%   

% Init 
% uniformly T = N x D dataset of binary strings for the test 
% Define M as the dataset of NearNeighbors of query q
%
D = 11;
N = 8;
% M nearneighbors for the test
M  = 3;

%T = zeros(N, D);
T = randi([0 1],  N-M,  D);  
% set the last one for the query q
q = T( end,  :);

% k hamming distance
k = 2;
X = zeros(M, D);
for i= 1 : M
    r = randi(D, 1, k);  %  k random num that are repeatable
    
    tmp = q;
    tmp(r) = not(tmp(r)) ;
    %T(end+1, :) = tmp;  % 
    X(i, :) = tmp;
end
T = [T; X];

% Split the instance p, q in T into l substrings on the 1st layer
l = 4;

rows = size(T, 1);
output = [];   % 

for i = 1 : rows
       % for each instance p
            
       %  result = findNearNeighbors(p_new,  q_new, C, options)
       result = kNN(T(i, :),  q,  k,  l);

        % get the index i of the instance p,
        
        if result == 0,
              output =[output, i]; 
        end
            
end

fprintf('The indexes of the %d near neighbors in T to the given query : \n', k);
fprintf('%5d', output);
fprintf('\n');
