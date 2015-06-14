clear, clc;
%
%            

%% Init
% uniformly T = N x D database of the binary code
D = 100000;
N = 100;
% M nearneighbors for the test
M  = 10;
%The search vector q
Q_n = 4; % the search size

%
l = 35;  %hash table number; the larger
h = 80;   % the width parameter;  the larger, the less buckets, the less candidates
%B = 3; % the max bucket size

% k hamming distance
k = 300;
%T = zeros(N, D);
T = randi([0, 1],  N-M,  D);

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

T_n = size(T, 1);  % gallery
ncandid = 11;  % output ncandid (or less) candidates

%% Hamming distance
hammhit = zeros(1, ncandid);
%tic;
for j = 1:Q_n
    dist = [];
    nnid = [];
    % Alice: true hamming distance for reference
    %ref = round(pdist2(q, T, 'hamming')*D);
    for i = 1:T_n
        d = round(pdist2(Q(j, :), T(i, :), 'hamming')*D);
        if d <= k
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
    fprintf('%5d(%d)', out');
    fprintf('\n');
    %fprintf('%5d', ref(nnid));
    
    %performance evaluation
    jshit = (nnid(:, 1) == j);
    if any(jshit),
        hammhit(jshit) = hammhit(jshit) + 1;
    end
    
end
fprintf('\n');
%toc;

%% LSH approach for the approximate n-NNS, which outputs the ncandid vector indices closest to each query q in Q

flag = 1;  %display the debug info 
% T is the gallery
% Q is the probe 
% l is the number of hash tables
% h is the width parameter
% 
% return the
[Ind, cnt] = ANN(T, Q, l, h, ncandid, flag);

annhit = zeros(1, ncandid);
 for i = 1 : Q_n  % in probe
       %
        out = [Ind(i, :); cnt(i, :)];
        fprintf('Q%d appr. %d-NNS (collision count): \n', i, ncandid);
        fprintf('%5d(%d)', out);
        fprintf('\n');
     
        % performance evaluation
         ishit = (Ind(i, :) == i);
         if any(ishit),
               annhit(ishit) = annhit(ishit) + 1;
         end
         
end
 
%
hammhitrate = cumsum(hammhit) / Q_n;
annhitrate = cumsum(annhit) / Q_n;

%%
figure(4); hold on;
title('The Indexing Performance on simulation dataset');
axis([0, ncandid,75, 100]);
plot(hammhitrate*100, 'k*--', 'MarkerSize', 8);
plot(annhitrate*100, 'r.--', 'MarkerSize',8);
xlabel('Penetration Rate (%)', 'FontSize', 14);
ylabel('Hit Rate (%)', 'FontSize', 14);

h = legend('Hamming', 'ANN', 2, 'Location', 'southeast');
set(h, 'FontSize', 10, 'position', [0.7, 0.12, 0.2, 0.2]);
hold off;
