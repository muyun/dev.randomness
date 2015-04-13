clear, clc;
% knn(q, k)
%
%
% TODO:
%       1.  code optimization  - Done
%       2.  return the candidate index list smaller than k hamming distance  -  to wrapper
%       

% Init 
% uniformly T = N x D dataset of binary strings for the test 
% Define M as the dataset of NearNeighbors of query q
%
D = 1100;
N =120;
% M nearneighbors for the test
M  = 23;

%T = zeros(N, D);
T = randi([0 1],  N-M,  D);  
% set the last one for the query q
q = T( end,  :);

% k hamming distance
k = 2;
% X is the test k nearneighbors
X = zeros(M, D);
for i= 1 : M
    %% Alice: NN dist should vary from 1 to k (except 0 for q itself)  
    % r = randi(D, 1, k);  %  k random num that are repeatable
    s = randi(k);
    r = randi(D, 1, s);  %  k random num that are repeatable
    
    tmp = q;
    tmp(r) = not(tmp(r)) ;
    %T(end+1, :) = tmp;  % 
    X(i, :) = tmp;
end

T = [T; X];
%% Alice: true hamming distance for reference
ref = pdist2(q, T, 'hamming')*D;
nnid = find(ref<=k);
disp('Ground Truth');
fprintf('%5d', nnid);
fprintf('\n');

% Split the instance p in T into l substrings on the 1st layer
%% Alice: k < l <= D/log_2 N - 1
l = 30; % faster
%l = floor(D/50);
%l = floor(D/log2(N)-1); %2 % takes longer

T_n = size(T, 1);
output = [];   % 
iterno = [];
for i = 1 : T_n
       % for each instance p
        [result, iter] = kNN(T(i, :),  q,  k,  l);

        % get the index i of the instance p,
        if result == 0, 
              output =[output, i]; 
              iterno = [iterno, iter];
        end
            
end

%fprintf('The indexes of the %d near neighbors in T to the given query : \n', k);
fprintf('NN(k<=%d) found: \n', k);
fprintf('%5d', output);
fprintf('\n No. iterations: \n');
fprintf('%5d', iterno);
fprintf('\n');
