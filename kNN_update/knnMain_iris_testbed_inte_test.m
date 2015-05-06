clear, clc
% Run indexing exp on face LSSC code
load('iriscode'); 

[nuser, nft] = size(gallery); 

nuser = 5;
ncandid = nuser;
nvalid = zeros(nuser, nuser);
hammhit = zeros(1, ncandid);
%knnhit = zeros(1, ncandid);
%nquery = 0; 

%kk = 0.2; %300;
% the threshold
Q1 = 0.45; %10;
Q2 = 0.55;
%s = (Q2- Q1)/ 10;
% SL = [];
% for i = 0 : 10
%     SL(end + 1) = Q1 + i * s;
% end
%SL = 20; % default step length
SL = (Q2-Q1)/5;

% gallery_ = gallery & ~gallery_mask;
% probe_ =  probe & ~probe_mask;
gallery= gallery & ~gallery_mask;
probe =  probe & ~probe_mask;

% for each probe, calc weighing factor with a candid
for j = 1:nuser
        pmask = ~probe_mask(j, :);
        if sum(pmask(:)) == 0; % skip this case
            continue;
        end

       for i = 1:nuser                        
                gmask = ~gallery_mask(i, :);
                 if sum(gmask(:)) == 0; % skip this case
                     continue;
                 end
                
                 %nvalid(i, j) = nft - nnz(pmask|gmask); % count true bits 
                valid = pmask & gmask;
                nvalid(i, j) = sum(valid(:));
                
       end
        
end

 % modified Hamming distance matching based on binary codes      
Dist = round(pdist2(gallery(1:nuser, :), probe(1:nuser, :), 'hamming')*nft);
Dist = Dist./nvalid;
[val, Indx] = sort(Dist); % sort each col in ascending order
%remove the inf element
%Indx = (~isinf(val)) & Indx;
%  for x1 = 1 : nuser
%      for x2 = 1 : nuser
%          if isinf(val(x1, x2)),
%              Indx(x1,x2) = 0;
%          end
%      end
%  end
 
hammInd = Indx(1:ncandid, :);

% Performance evaluation 
for j = 1:nuser
    ishit = (hammInd(:, j)==j);
    if any(ishit)               
%               Hdist = ceil(Dist(ishit, j)*nft); 
       hammhit(ishit) = hammhit(ishit)+1; 
       % note radii value starting from 0
    %   radii(Hdist+1) = radii(Hdist+1)+1;
    %   NN(ishit, Hdist) = NN(ishit, Hdist)+1;
    end
end
fprintf('\n');


%% kNN 
Ind = zeros(nuser, ncandid);
rad = zeros(nuser, ncandid);
knnhit = zeros(1, ncandid);
l = floor(nft/31) + 1;

%profile on;
%tic;
for jj = 1 : nuser % in probe
    % each instance q in the probe
    %q = probe(jj, :);
    Ind_q = [];
    radius = [];
    for kk =Q1 : SL : Q2
        output = [];   %
        iterno = [];
        
        for ii = 1 : nuser
%             g = gallery(ii , :);       
            % for each instance p
            step = kk * nvalid(ii ,jj);
            if step == 0;
                  result = 0;
                  iter = 0;
            elseif sum(gallery(ii , :)) == 0 || sum(probe(jj, :)) == 0,
                     result = 0;
                     iter = 0;
             else
                    [result, iter] = kNN(gallery(ii , :), probe(jj, :),  step,  l);
                
            end
            
            % get the index i of the instance p,
            if result == 1,
                output =[output, ii];
                iterno = [iterno, iter];
            end
            
        end
        
        adding = setdiff(output, Ind_q);
        if ~isempty(adding),
             Ind_q = [Ind_q, adding];
             radius = [radius, repmat(floor(step), 1, length(adding))];
        end
    end
    
    len_ind_q = length(Ind_q);
    if len_ind_q <= ncandid
        Ind(jj , 1:len_ind_q) = Ind_q;
        rad(jj, 1:len_ind_q) = radius;
    else
        Ind(jj, :) = Ind_q(1:ncandid);
        rad(jj, :) = radius(1:ncandid);
    end
    
%    if flag == 1,
        out = [Ind(jj, :); rad(jj, :)];
        fprintf('Q%d NN found: \n', jj);
        fprintf('%5d(%d)', out);
        fprintf('\n');
%    end
    
      % performance evaluation
    ishit = (Ind(jj, :) == jj);
    if any(ishit),
        knnhit(ishit) = knnhit(ishit) + 1;
    end
    
end

hammhitrate = cumsum(hammhit)/nuser;
knnhitrate = cumsum(knnhit)/nuser;

figure(3); hold on;
title('The Indexing Performance');
axis([0, ncandid,75, 100]);
plot(hammhitrate*100, 'k*--', 'MarkerSize', 8);
plot(knnhitrate*100, 'r--', 'MarkerSize',8);
xlabel('Penetration Rate (%)', 'FontSize', 14);
ylabel('Hit Rate (%)', 'FontSize', 14);

h = legend('Hamming', 'kNN', 2, 'Location', 'southeast');
set(h, 'FontSize', 10, 'position', [0.7, 0.12, 0.2, 0.2]);
hold off;

%title('FRGC DB - 150 gallery, 150 x 5 search');
% figure(5);
% plot(radii, 'k.', 'MarkerSize', 7);
% xlabel('Hamming Radius Needed', 'FontSize', 12);
% ylabel('pdf', 'FontSize', 12);
% title('FRGC DB - 150 gallery, 150 x 5 search');
%figure(3); hold on;
%plot(cumsum(radii/nquery), 'k--');
%xlabel('Hamming Radius Needed', 'FontSize', 14);
%ylabel('CDF', 'FontSize', 14);
%hold off;
% query that couldn't find a match