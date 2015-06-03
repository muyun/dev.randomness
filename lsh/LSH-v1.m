function indices = LSH(q, T, h, l)
%
% hash functions
% l = 3;
% %
% h = 3;

% T = randi([0, 1],  N,  D);
% q = T(end, :); %the search vector
% 
% T_n = size(T, 1);

%Preprocessing - enroll  the data for the training
% generate random hash functions
hash_indexes = {};
for i = 1 :  h 
       r = randi(D, 1,  h);
       
       hash_functions{i} = r;
end

%
%buckets = {};
hashtables = cell(2^l, l); % store the l hash tables

%structure of arrays
%hash_functions = struct('function','','','');
%buckets = cell(1, 2^l);
buckets = containers.Map();

for i = 1 : T_n
          % for each vector in T
          v = T(i, :);  
          b = [];
          %buckets = cell(1, 2^l);
          %str = struct('key', '', 'indexes', buckets);
          
          for j = 1 :  l  
                  %for each  hash table
                   r =  hash_functions{j};
                   ind = v(r);   % the hash function
                   
                   key = bi2de(ind) + 1;  % the bucket index

                   % store the index in bucket b of  hash table k 
                   %bucket{key} = b;
                   if ~isempty(buckets{key})
                         b = buckets{key};
                         buckets{key} = [b, i];
                   else
                         buckets{key} = i;
                   end
                   
                   % hash tables
                  % lsh_indexing(k, :) = buckets{key};
%                   for k = 1 : 2^l
%                         hashtables{j,k} = buckets{k};
%                   end
                   hashtables{key, j} = buckets{key};
          end  
          
          % hash tables
         % structure of arrays     
              
%           % hash tables
%             for kk = 1 : l
%                    %if isempty(lsh_indexing{k})
%                          lsh_indexing{kk, :} = hashtables{kk};
%                    %end
%             end
    
end



