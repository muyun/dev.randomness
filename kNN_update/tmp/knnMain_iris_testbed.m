clear, clc
% Run indexing exp on face LSSC code
load('data/iriscode'); 

[nuser, nft] = size(gallery); 
ncandid = 30;
nvalid = zeros(nuser, nuser);
hammhit = zeros(1, ncandid);
knnhit = zeros(1, ncandid);
nquery = 0; 
 
for l = 1:1
    % Create gallery dataset 
    % Create probe dataset
    for i = 1:1                
        % for each probe, calc weighing factor with a candid
        for j = 1:nuser
            pmask = probe_mask(j, :);
            for k = 1:nuser
                gmask = gallery_mask(k, :);
                nvalid(k, j) = nft - nnz(pmask|gmask); % count true bits 
            end
        end
         % modified Hamming distance matching based on binary codes      
        Dist = round(pdist2(gallery, probe, 'hamming')*nft);
        Dist = Dist./nvalid;
        [val, Indx] = sort(Dist); % sort each col in ascending order
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
        
        %% kNN 
        flag = 1; %display for debug or not
        knnInd = knnProbeset(gallery, probe, nvalid, ncandid, flag);
        
      % Performance evaluation 
        for j = 1:nuser
            ishit = (knnInd(:, j)==j);
            if any(ishit)               
%               Hdist = ceil(Dist(ishit, j)*nft); 
               knnhit(ishit) = knnhit(ishit)+1; 
               % note radii value starting from 0
            %   radii(Hdist+1) = radii(Hdist+1)+1;
            %   NN(ishit, Hdist) = NN(ishit, Hdist)+1;
            end
        end
        
       nquery = nquery + nuser;
    end
end
hammhitrate = cumsum(hammhit)/nquery;
knnhitrate = cumsum(knnhit)/nquery;

figure; hold on;
title('The Indexing Performance');
plot(hammhitrate*100, 'k.--', 'MarkerSize', 8);
plot(knnhitrate*100, 'r.--', 'MarkerSize',8);
xlabel('Penetration Rate (%)', 'FontSize', 14);
ylabel('Hit Rate (%)', 'FontSize', 14);

h = legend('smallest hamming', 'kNN', 2, 'Location', 'southeast');
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