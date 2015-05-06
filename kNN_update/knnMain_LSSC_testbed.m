clear, clc
% Run indexing exp on face LSSC code
load('data/FERET_short');
%load('../data/FERET_short'); 

[nft0, nsamp, nuser] = size(bin_w);
% nft = nft0;
nbit = 7; % #MSB
ndim = 64;  % #features
nft = nbit*ndim;
ncandid = 30;
hammhit = zeros(1, ncandid);
knnhit = zeros(1, ncandid);
nquery = 0;
% radii = zeros(1, nft+1); % radii[1]=0
%NN = zeros(ncandid, nft);

probe = zeros(nuser, nft);
gallery = zeros(nuser, nft);  

matrix = zeros(7, 64);
temp = zeros(nft0, 1); 
matrix2 = zeros(nbit, ndim);

for l = 1
    % Create gallery dataset
    for j = 1:nuser
        temp = bin_w(:, l, j)'; 
%       gallery(j, :) = temp;   
        matrix(:) = temp;
        % most significant bits
        matrix2 = matrix((8-nbit):7, 1:ndim);
        gallery(j, :) = matrix2(:); 
    end
    % Create probe dataset
    for i = l+1
        for j = 1:nuser
            temp = bin_w(:, i, j)';
%            probe(j, :) = temp;
            matrix(:) = temp;
            % most significant bits
            matrix2 = matrix((8-nbit):7, 1:ndim);
            probe(j, :) = matrix2(:); 
        end    
        
        %% Hamming distance matching based on binary codes
        % Replace the line below with privacy-preserving kNN code
       [Dist, hammInd] = pdist2(gallery, probe, 'hamming', 'Smallest', ncandid);
         % "Ind" only n_probe \timex n_candidates

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
        knnInd = knnProbeset(gallery, probe, ncandid, flag);
        
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

figure(4); hold on;
title('The Indexing Performance');
plot(hammhitrate*100, 'k.--', 'MarkerSize', 8);
plot(knnhitrate*100, 'r.--', 'MarkerSize',8);
xlabel('Penetration Rate (%)', 'FontSize', 14);
ylabel('Hit Rate (%)', 'FontSize', 14);

h = legend('Smallest Hamming', 'kNN', 2, 'Location', 'southeast');
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