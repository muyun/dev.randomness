%clear, clc;
function Ind = knnProbeset(T, Q, ncandid, flag)
%
%
%flag = 1;
if nargin <4,
    flag = 0; % donot display for debug
end

%
T_n = size(T, 1);  % gallery
Q_n = size(Q, 1);  %probe
D = size(T, 2);
% the threshold
%Q1 = 50;
%Q2 = 150;
%SL = 2; % default step length
%SL = Q2 - Q1;
SL = [50,70,90,110,120,125,130,135,140,150]; % The step length in the face LSSC test
l = floor(D/28) + 1;

Ind = zeros(Q_n, ncandid);
rad = zeros(Q_n, ncandid);
%profile on;
%tic;
for i = 1 : Q_n % in probe
    % each instance q in the probe
    q = Q(i, :);
    Ind_q = [];
    radius = [];
    for step = SL
        output = [];   %
        iterno = [];
        
        for j = 1 : T_n
            % for each instance p
            [result, iter] = kNN(T(j, :),  q,  step,  l);
            
            % get the index i of the instance p,
            if result == 1,
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
        rad(i, 1:len_ind_q) = radius;
    else
        Ind(i, :) = Ind_q(1:ncandid);
        rad(i, :) = radius(1:ncandid);
    end
    
    if flag == 1,
        out = [Ind(i, :); rad(i, :)];
        fprintf('Q%d NN found: \n', i);
        fprintf('%5d(%d)', out);
        fprintf('\n');
    end
end

% get the ncandid index
Ind = Ind';

%toc;
%profile viewer
%p = profile('info');
%profsave(p,'profile_results')