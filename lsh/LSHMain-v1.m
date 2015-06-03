%clear, clc;
%

% Init
% uniformly T = N x D dataset of binary strings for the test
D = 20;
N =3;

% hash functions
l = 4;
%
h = 4;

%T = zeros(N, D);
T = randi([0, 1],  N,  D);
q = T(end, :); %the search vector

T_n = size(T, 1);

%Preprocessing
% generate random hash functions
hash_indexes = {};
for i = 1 :  l 
       r = randi(D, 1,  l);
       
       hash_indexes{i} = r;
end

%
%buckets = {};
hashtables = cell(2^l, l);
%lsh_indexing = cell(2^l, l);

%structure of arrays
%hash_functions = struct('function','','','');
buckets = cell(1, 2^l);
for i = 1 : T_n
          % for each vector
          v = T(i, :);  
          b = [];
          %buckets = cell(1, 2^l);
          %str = struct('key', '', 'indexes', buckets);
          
          for j = 1 :  l  %for each  hash table
                   r =  hash_indexes{j};
                   ind = v(r);  % the hash index
                   key = binaryVectorToDecimal(ind) + 1;  % the bucket

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
%           for k = 1 : l
%                   for kk = 1 : 2^l
%                         hashtables{kk, k} = buckets{kk};
%                   end
%           end 
         
              
%           % hash tables
%             for kk = 1 : l
%                    %if isempty(lsh_indexing{k})
%                          lsh_indexing{kk, :} = hashtables{kk};
%                    %end
%             end
          
%           for k = 1 :  l
%                     lsh_indexing{k} = hashtables;
%            end

          
end

