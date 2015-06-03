clear, clc;
load('data.mat'); % 120 x 10000

% the parameters
HTableNum = 20;  % the number of hash tables;  the larger is the better
%Keylength = 24;
Keylength=5;    % the width parameter is larger, the less buckets, the less candidates
%
K = 5;   % K (or less) appr. nearest neighbors of each query vector q
flag = 1;  % display the debug info
%
Q_n=3;  % the query number
for i=1 : Q_n
        %tic
        [nnlsh, numcand] = LSH(T(:,i)', T', HTableNum, Keylength, K, flag);
        %toc
        out = [nnlsh, numcand];
        fprintf('Q%d Approximate %d-NNS: \n', i, K);
        fprintf('%5d(%d)', out');
        fprintf('\n');
end






