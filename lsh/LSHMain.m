clear, clc;
%
%            

% Init
% uniformly T = N x D database of the binary code
D = 100000;
N = 100;
% M nearneighbors for the test
M  = 10;
%The search vector q
Q_n = 3; % the search size

%
l = 35;  % the number of hash tables
h = 80;   % the width parameter;  the larger width, the less candidates
%B = 3; % the max bucket size

% k hamming distance
k = 300;
%T = zeros(N, D);
T = randi([0, 1],  N-M,  D);
%q = T(end, :); %the search vector


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
%hammhit = zeros(1, ncandid);
%tic;
for j = 1:Q_n
    dist = [];
    nnid = [];
    %% Alice: true hamming distance for reference
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
    
%     %performance evaluation
%     jshit = (nnid(:, 1) == j);
%     if any(jshit),
%         hammhit(jshit) = hammhit(jshit) + 1;
%     end
    
end
fprintf('\n');
%toc;

% LSH approach for the approximate n-NNS, which outputs the n vectors closest to q
flag = 1;  %display the debug info 
ncandid = 11;  % output ncandid (or less) appr. nearest neighbors
for i = 1: Q_n
        q = Q(i, :);    % the query  vector
        
        % T is used for the training
        % l is the number of hash tables
        % h is the width parameter
        % return n (or less) appr. nearest neighbors of q in set T,
        % num parameter is the corresponding collision count
        [nnid, num] = LSH(q, T, l, h, ncandid, flag);
        
        out = [nnid, num];
        fprintf('Q%d appr. %d-NNS (collision count): \n', i, ncandid);
        fprintf('%5d(%d)', out');
        fprintf('\n');
        
end

