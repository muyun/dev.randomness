clear, clc
% Run indexing exp on iris code
load('FERET_short'); 

[nft0, nsamp, nuser] = size(bin_w);
%
nbit = 7; % #MSB
ndim = 64;  % #features
nft = nbit*ndim;
%
probe = zeros(nuser, nft);
gallery = zeros(nuser, nft);  
%
matrix = zeros(7, 64);
temp = zeros(nft0, 1); 
matrix2 = zeros(nbit, ndim);

%
l = 45;  %hash table number; the larger
h = 120;   % the width parameter;  the larger, the less buckets, the less candidates
%B = 3; % the max bucket size

ncandid = 30;
nvalid = zeros(nuser, nuser);
hammhit = zeros(1, ncandid);
annhit = zeros(1, ncandid);
nquery = 0; 

nsamp = 2;
for ll = 1 : nsamp - 1
      % create gallery dataset
       for j = 1 : nuser
                temp = bin_w(:, ll, j)'; 
            %       gallery(j, :) = temp;   
                matrix(:) = temp;
                % most significant bits
                matrix2 = matrix((8-nbit):7, 1:ndim);
                gallery(j, :) = matrix2(:); 
       end
        
       % 
       for i = ll+1 : nsamp
               %Create probe dataset
                for j = l : nuser
                        temp = bin_w(:, i, j)';
                    %            probe(j, :) = temp;
                        matrix(:) = temp;
                        % most significant bits
                        matrix2 = matrix((8-nbit):7, 1:ndim);
                        probe(j, :) = matrix2(:); 
                end 
                
                % Hamming distance
                [Dist, hammInd] = pdist2(gallery, probe, 'hamming', 'Smallest', ncandid);
                
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
                  
                 
                  % ANN
                   [Ind, cnt] = ANN(gallery, probe, l, h, ncandid, 1);
                   
                   for j = 1 : nuser
                           jshit = (Ind(j, :) == j);

                           if any(ishit),
                                 annhit(ishit) = annhit(ishit) + 1;
                           end
                      
                   end
                   
                   nquery = nquery + nuser;
       end
end

%
hammhitrate = cumsum(hammhit)/nquery;
annhitrate = cumsum(annhit)/nquery;

figure(4); hold on;
title('The Indexing Performance');
axis([0, ncandid,40, 100]);
plot(hammhitrate*100, 'k*--', 'MarkerSize', 8);
plot(annhitrate*100, 'r.--', 'MarkerSize',8);
xlabel('Penetration Rate (%)', 'FontSize', 14);
ylabel('Hit Rate (%)', 'FontSize', 14);

h = legend('Hamming', 'ANN', 2, 'Location', 'southeast');
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