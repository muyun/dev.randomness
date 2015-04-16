clear, clc
% Run indexing exp on face LSSC code
load('FERET_short');
%load('../data/FERET_short'); 

[nft0, nsamp, nuser] = size(bin_w);
% nft = nft0;
nbit = 7; % #MSB
ndim = 64;  % #features
nft = nbit*ndim;
ncandid = 30;
hit = zeros(1, ncandid);
nquery = 0;
% radii = zeros(1, nft+1); % radii[1]=0
%NN = zeros(ncandid, nft);

probe = zeros(nuser, nft);
gallery = zeros(nuser, nft);  

matrix = zeros(7, 64);
temp = zeros(nft0, 1); 
matrix2 = zeros(nbit, ndim);
for l = 1:nsamp-1
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
    for i = l+1:nsamp
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
       %[Dist, Ind] = pdist2(gallery, probe, 'hamming', 'Smallest', ncandid);
       Ind = knnMain(gallery, probe, ncandid);
        % "Ind" only n_probe \timex n_candidates
       
        
        
        %% Performance evaluation 
        for j = 1:nuser
            ishit = (Ind(:, j)==j);
            if any(ishit)               
%               Hdist = ceil(Dist(ishit, j)*nft); 
               hit(ishit) = hit(ishit)+1; 
               % note radii value starting from 0
            %   radii(Hdist+1) = radii(Hdist+1)+1;
            %   NN(ishit, Hdist) = NN(ishit, Hdist)+1;
            end
        end
       nquery = nquery + nuser;
    end
end
hitrate = cumsum(hit)/nquery;
figure(4); hold on;
plot(hitrate*100, 'k.--', 'MarkerSize', 8);
xlabel('Penetration Rate (%)', 'FontSize', 14);
ylabel('Hit Rate (%)', 'FontSize', 14);
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