%clear, clc;
%function Ind = knnMain_probeset_v3(T, Q, l, ncandid, flag)
%
%
flag = 1;
% if nargin <5,
%     flag = 0; % donot display for debug
% end
% Init
% uniformly T = N x D dataset of binary strings for the test
% Define M as the dataset of NearNeighbors of query q

D = 2048;
N =100;
% M nearneighbors for the test
M  = 10;
Q_n = 4; % probe size
% Split the instance p in T into l substrings on the 1st layer
%% Alice: k < l <= D/log_2 N - 1
% the lower bound -  For the variable-precision in matlab,  floor(D / l) + 1 <= 32 => l > D/31
l = floor(D/31) + 1;
%l = floor(600/log2(1000)-1);
% 
%l = 10;
%l = 4;
% % k hamming distance
k = 0.2; %300;
% the threshold
Q1 = 0.05; %10;
Q2 = k;
%SL = 20; % default step length
SL = (Q2-Q1)/10;

% get the ncandid indiceds
ncandid = M + 1;  % selected candid
%T = zeros(N, D);
T = randi([0, 1],  N-M,  D);
Q = [];
for j = 1:Q_n
    % set the last one for the query q
    q = T(j,  :);
    
    % X is the test k nearneighbors
    X = zeros(M, D);
    for i= 1 : M
        %% Alice: NN dist should vary from 1 to k (except 0 for q itself)
        % r = randi(D, 1, k);  %  k random num that are repeatable
        s = randi(round(k*D));
        r = randi(D, 1, s);  %  k random num that are repeatable
        
        tmp = q;
        tmp(r) = not(tmp(r)) ;
        X(i, :) = tmp;
    end
    T = [T; X];
    Q = [Q; q];    
end
T = logical(T);
Q = logical(Q);
T_n = size(T, 1); 
Q_n = size(Q, 1);

% generate masks
maxInvalid = 200;
T_mask = ones(T_n, D);
Q_mask = ones(Q_n, D);
for j = 1:T_n
    nInvalid = randi(maxInvalid);
    invalidbits = randi(D, 1, nInvalid);
    T_mask(j, invalidbits) = 0;
    T_mask = logical(T_mask);
end
for j = 1:Q_n
    nInvalid = randi(maxInvalid);
    invalidbits = randi(D, 1, nInvalid);
    Q_mask(j, invalidbits) = 0;
    Q_mask = logical(Q_mask);
end
% simulate iris template
gallery = T & T_mask;
probe = Q & Q_mask;
 
hammhit = zeros(1, ncandid);
tic;
for j = 1:Q_n
    dist = [];
    nnid = [];
    %% Alice: true hamming distance for reference
    %ref = round(pdist2(q, T, 'hamming')*D);
    for i = 1:T_n
        d = round(pdist2(probe(j, :), gallery(i, :), 'hamming')*D);        
        valid = Q_mask(j, :) & T_mask(i, :);
        nvalid = sum(valid(:));  
        if d <= k * nvalid
            nnid = [nnid; i];
            dist = [dist; d];
        end
    end
    [ans, sid] = sort(dist);
    dist = dist(sid);
    nnid = nnid(sid);
    
    %nnid = find(ref<=k);
    out = [nnid, dist];
    fprintf('Q%d ground truth (Hamming distance)\n', j);
    fprintf('%5d(%3d)', out');
    fprintf('\n');
    %fprintf('%5d', ref(nnid));
    
    %performance evaluation
    isHit = (nnid(:, 1) == j);
    if any(isHit),
        hammhit(isHit) = hammhit(isHit) + 1;
    end
    
end
fprintf('\n');
toc;

Ind = zeros(Q_n, ncandid);
rad = zeros(Q_n, ncandid);
knnhit = zeros(1, ncandid);
%profile on;
tic;
for i = 1 : Q_n % in probe
    % each instance q in the probe 
    Ind_q = [];
    radius = [];
    for kk = Q1: SL : Q2
        output = [];   %
        iterno = [];
        
        for j = 1 : T_n
            % for each instance p
            valid = Q_mask(i, :) & T_mask(j, :);
            nvalid = sum(valid(:));
            step = kk * nvalid;
            if step == 0
                result = 0;
                iter = 0;
            else
                [result, iter] = kNN(gallery(j, :),  probe(i, :),  step,  l);
            end
            
            % get the index i of the instance p,
            if result == 1
                output =[output, j];
                iterno = [iterno, iter];
            end            
        end        
        adding = setdiff(output, Ind_q);
        if ~isempty(adding),
             Ind_q = [Ind_q, adding];
             radius = [radius, repmat(step, 1, length(adding))];
        end
    end
    
    len_ind_q = length(Ind_q);
    if len_ind_q <= ncandid
        Ind(i, 1:len_ind_q) = Ind_q;
        rad(i, 1:len_ind_q) = round(radius);
    else
        Ind(i, :) = Ind_q(1:ncandid);
        rad(i, :) = round(radius(1:ncandid));
    end
    
    if flag == 1,
        out = [Ind(i, :); rad(i, :)];
        fprintf('Q%d NN found: \n', i);
        fprintf('%5d(%d)', out);
        fprintf('\n');
    end
    
    % performance evaluation
    ishit = (Ind(i, :) == i);
    if any(ishit),
        knnhit(ishit) = knnhit(ishit) + 1;
    end
end

% get the ncandid index
Ind = Ind';

toc;

hammhitrate = cumsum(hammhit)/Q_n;
knnhitrate = cumsum(knnhit)/Q_n;

figure(2); hold on;
title('The Indexing Performance on testset');
axis([0, ncandid,75, 100]);
plot(hammhitrate*100, 'k*--', 'MarkerSize', 8);
plot(knnhitrate*100, 'r.--', 'MarkerSize',8);
xlabel('Penetration Rate (%)', 'FontSize', 14);
ylabel('Hit Rate (%)', 'FontSize', 14);

h = legend('hamming', 'kNN', 2, 'Location', 'southeast');
set(h, 'FontSize', 10, 'position', [0.7, 0.12, 0.2, 0.2]);
hold off;
%profile viewer
%p = profile('info');
%profsave(p,'profile_results')