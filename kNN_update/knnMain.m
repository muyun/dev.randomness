clear, clc; 
%
%   

% Init 
% uniformly T = N x D dataset of binary strings for the test 
% Define M as the dataset of NearNeighbors of query q
%
D = 600;
N =100;
% M nearneighbors for the test
M  = 10;

%T = zeros(N, D);
T = randi([0, 1],  N-M,  D);  
% set the last one for the query q
q = T( end,  :);

% k hamming distance
k = 260;
% X is the test k nearneighbors
Q = zeros(M, D);
for i= 1 : M
    %% Alice: NN dist should vary from 1 to k (except 0 for q itself)  
    % r = randi(D, 1, k);  %  k random num that are repeatable
    s = randi(k);
    r = randi(D, 1, s);  %  k random num that are repeatable
    
    tmp = q;
    tmp(r) = not(tmp(r)) ;
    %T(end+1, :) = tmp;  % 
    Q(i, :) = tmp;
end

T = [T; Q];
dist = [];
nnid = [];
%% Alice: true hamming distance for reference
tic;
%ref = round(pdist2(q, T, 'hamming')*D);
for i = 1:N
   d = round(pdist2(q, T(i, :), 'hamming')*D);
   if d <= k
       nnid = [nnid; i];
       dist = [dist; d];
   end
end
%nnid = find(ref<=k);
disp('Ground Truth');
fprintf('%5d', nnid);
fprintf('\n');
fprintf('Hamming distance\n');
%fprintf('%5d', ref(nnid));
fprintf('%5d', dist);
fprintf('\n');
toc;

% Split the instance p in T into l substrings on the 1st layer
%% Alice: k < l <= D/log_2 N - 1
l = 4; % faster
%l = floor(D/50);
%l = floor(D/log2(N)-1); %2 % takes longer

ncandid = 10;  % selected candid

profile on;
tic;

% get the ncandid indices
Ind = kNN(T,  Q, l, ncandid);

toc;  
profile viewer
p = profile('info');
profsave(p,'profile_results')