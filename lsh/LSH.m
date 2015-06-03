function [nnid, dist]= LSH(q, T, L, H, K, flag)
% Locality-Sensitive Hashing Scheme based on Random Bits Sampling
% Return the K  (or less) appr. nearest neighbors of q found in set T
%
%  INPUT: 
%                     T  -      A set  for vectors
%                     q  -      the query vector
%
%                     L   -    the number of hash tables
%                     H  -     the width parameter
%                     K  -     appr. nearest neighbors of q
%                     flag -  whether to display the debug info
%
%  OUTPUT:
%                      nnid   -   indices of appr. nearest neighbors in T
%                      dist   -     the corresponding hamming distance
%
if nargin < 6,
     flag = 0;  % donot display for the debug info
end

D = size(T, 2);
T_n = size(T, 1);

%the times the random protocol executes the work
%m = 1;

% L hash functions are defined by randomly choosing L subsets
hash_functions = cell(1, L);  
for i = 1 :  L   
       %hash function g is obtained by concatenating h randomly chosen subsets in D
       %r = randi(D, 1, H);  
       r = unidrnd(D, 1, H);
	   
       hash_functions{i} = r;  % just store the indices here 
end

% store a map in each hash table if only non-empty buckets are stored
for i = 1 : L
    hashtables{i} = containers.Map('KeyType','int32', 'ValueType','any');  
end

if flag == 1,
    hashkeys = cell(T_n, L); % used for the test
end

%Preprocessing - construct L hash tables
for i = 1: L
       %for each  hash table
       r =  hash_functions{i};  %
       
       h= hashtables{i};  %the map in the hash table
       
       b = [];
       
       % hash all vectors from T into each of the L hash tables
       for j= 1 : T_n
                 % for each vector in T
                 v = T(j, :); 
                 bin = v(r);   % randomly chosen hash function

                  %As the total number of buckets may be large, standard hash functions to reduce the amout of
                  % memory used per hash table to O(n)
                   
                  key = bi2de(bin,'left-msb');  % hash the H binary vector to a natural number
                  %[p, s] = second_hash(bin, m);  %  s as the bucket entry
                    
                  if flag == 1,
                          hashkeys{j, i} = key;   %
                  end
                      
                   if  isKey(h, key),
                          b = h(key);
                          
                          h(key) = unique([b, j]);
                  else
                          h(key) = j;
                   end 

        end  
             
end

% Query answering algorithm to perform similarity search
%   return the K appr. nearest neighbors for each query vector q
indices = [];
for i = 1 : L  % access to L hash tables
      % for each hashtable
       qr =  hash_functions{i}; % the hash functions are applied to the query q
       bin_q = q(qr);   % the bucket 
       key = bi2de(bin_q,'left-msb');  % hash the h binary vector to a natural number
       %key = second_hash(bin_q, m); %  s as the bucket entry
       
       hash_q = hashtables{i};  % the map function

       % all the vectors in the same buckets as q are retrieved as candidates
       if isKey(hash_q, key)
             output = hash_q(key);  %
       else
             continue;
       end

       indices = union(output,  indices);

end

% To rank the candidates (only those vectors that collide with q) according to their hamming distance
dist = [];
nnid = [];
for i = 1 : length(indices)
       ind = indices(i);
       d = round(pdist2(q, T(ind,:), 'hamming')*D);
       
       nnid = [nnid; ind];
       dist = [dist; d]; 
end

if length(nnid) <= K,
        [ans, sid] = sort(dist);
else
        [ans, sid] = sort(dist(1:K));
end
dist = dist(sid);
nnid = nnid(sid);

%based on randomized protocol
% return the prime p and the module prime s
function [p, s] = second_hash(bin, m)
     %m = 2;  %the times the protocol executes the work
     n = length(bin);
     
     all_ps = primes(n^2);
     nps = length(all_ps);
     pick = randi([2, nps], 1, m);
     p =all_ps(pick);

     de = bi2de(bin,'left-msb');  % hash the h binary vector to a natural number

     s = mod(de, p);
%      end
