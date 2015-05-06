clear, clc;
flag = 1; % display for debug

% Init
% uniformly T = N x D dataset of binary strings for the test
% Define M as the dataset of NearNeighbors of query q

D = 10000;
N =100;
% M nearneighbors for the test
M  = 10;

%T = zeros(N, D);
T = randi([0, 1],  N-M,  D);
% set the last one for the query q
y = T( end,  :);

% k hamming distance
k = 300;
% X is the test k nearneighbors
X = zeros(M, D);
for i= 1 : M
    %% Alice: NN dist should vary from 1 to k (except 0 for q itself)
    % r = randi(D, 1, k);  %  k random num that are repeatable
    s = randi(k);
    r = randi(D, 1, s);  %  k random num that are repeatable
    
    tmp = y;
    tmp(r) = not(tmp(r)) ; 
    X(i, :) = tmp;
end

T = [T; X];
dist = [];
nnid = [];
%% Alice: true hamming distance for reference
tic;
%ref = round(pdist2(q, T, 'hamming')*D);
for i = 1:N
    d = round(pdist2(y, T(i, :), 'hamming')*D);
    if d <= k
        nnid = [nnid; i];
        dist = [dist; d];
    end
end
%nnid = find(ref<=k);
disp('Ground Truth (Hamming)');
fprintf('%5d(%d)', [nnid, dist]');
fprintf('\n');
%fprintf('Hamming distance\n');
%fprintf('%5d', ref(nnid));
%fprintf('%5d', dist);
fprintf('\n');
toc;


% Split the instance p in T into l substrings on the 1st layer
%% Alice: k < l <= D/log_2 N - 1
%l = floor(600/log2(1000)-1);
l = 4;

% get the ncandid indices
Q = y;
T_n = size(T, 1);  % gallery
Q_n = size(Q, 1);  % probe
ncandid = 10;  % selected candid

%Ind = zeros(Q_n, ncandid);

% the threshold
Q1 = 100;
Q2 = k;
%SL = 20; % default step length
SL = 50;

%profile on;
tic;
for i = 1 : Q_n % in probe
    % each instance q in the probe
    q = Q(i, :);
    Ind_q = [];
    radius = [];
    for step = Q1: SL : Q2
        output = [];   %
        iterno = [];
        
        for j = 1 : T_n
            % for each instance p            
            [result, iter] = kNN(T(j, :),  q,  step,  l);
            
            if j > 90,
                disp(j);
            end
            
            % get the index i of the instance p,
            if result == 0,
                output =[output, j];
                iterno = [iterno, iter];
            end
        end
        
        adding = setdiff(output, Ind_q);
        Ind_q = [Ind_q, adding];        
        radius = [radius, repmat(step, 1, length(adding))]; 
        if flag ~= 0
            out = [Ind_q; radius];
            fprintf('Q%d NN found: \n', i);
            fprintf('%5d(%d)', out); 
            fprintf('\n');
        end      
                
    end
    
%     len_ind_ = length(Ind_);
%     if len_ind_ <= ncandid,
%         Ind_(len_ind_ + 1 : ncandid) = 0;
%     else
%         Ind_(ncandid + 1 : len_ind_) = [];
%     end
    
%    Ind(i, :) = Ind_q;
end

% get the ncandid index
%Ind = Ind';

toc;
%profile viewer
%p = profile('info');
%profsave(p,'profile_results')