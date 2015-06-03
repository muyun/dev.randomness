clear, clc;
% Test the implementation of LSH Based on Random Bits Sampling

% Init
% uniformly T = N x D dataset of the binary strings
D = 12;
N =3;
% M nearneighbors for the test
M  = 2;
%
L = 11;  % the number of hash tables
%
H = L;   % the width parameter, (should be more than 5)
B = 3; % the max bucket size, should be less than H

K = 2;
%T = zeros(N, D);
% T
T = randi([0, 1],  N,  D);
%q = T(end, :); %the search vector
T_n = size(T, 1);

%The search vector
Q_n = 1; % search size
Q = [];
for i = 1 : Q_n
        q = T(i, :);

        X = zeros(M, D);
        for j = 1 : M
                s = randi(k);
                r = randi(D, 1, s); % only for the test
                
                tmp = q;
                tmp(r) = not(tmp(r)) ;
                X(j, :) = tmp;
        end
        
         T = [T;  X];
         Q = [Q;  q];
end

% LSH approach for the approximate k-NNS
flag = 1;  %display the debug info 
n = 5;  %might output n (or less) appr. nearest neighbors
for i = 1: Q_n
        % for each query
        q = Q(i, :);       
        % T is used for the training
        % L is the number of hash tables
        % H is the hash table size
        % K is the required appr. nearest neighbors for each query vector
        %  return the indexes of appr. nearest neighbors in T
        % based on Random Bits Sampling
        [nnid, dist] = LSH(q, T, L, H, K, flag);
        
        % need a threshold
        out = [nnid, dist];
        fprintf('Q%d Approximate NNS: \n', i);
        fprintf('%5d(%3d)', out');
        fprintf('\n');
        
end

