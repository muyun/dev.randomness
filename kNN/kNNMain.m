clear, clc;
% knn(q, k)
%
% divide-and-conquer
%
% TODO:
%       1.  update the code 
%       2.  fix the prime err in randomizedProtocol code  - Done
%       3.  return the candidate index list smaller than k hamming distance  -  to wrapper
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

% X is the test k nearneighbors
X = zeros(M, D);
for i= 1 : M
    r = randi(D, 1, k);  %  k random num that are repeatable
    
    tmp = q;
    tmp(r) = not(tmp(r)) ;
    %T(end+1, :) = tmp;  % 
    X(i, :) = tmp;
end

T = [T; X];

% Split the instance p in T into l substrings on the 1st layer
l = 3;

T_n = size(T, 1);
output = [];   % 

for i = 1 : T_n
       % for each instance p
        result = kNN(T(i, :),  q,  k,  l);

        % get the index i of the instance p,
        if result == 0,
              output =[output, i]; 
        end
            
end

fprintf('The indexes of the %d near neighbors in T to the given query : \n', k);
fprintf('%5d', output);
fprintf('\n');
