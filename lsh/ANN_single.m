function [nnid, num]= ANN_single(q, T, l, h, n, flag) 
% Return the n (or less) appr. nearest neighbors of query q found in set T
%LSH based on Random Bits Sampling
%
%  INPUT: 
%                     T  -      A set  for vectors
%                     q  -      the query vector
%           
%                     l   -    the number of hash tables
%                     h  -     the width parameter
%                     n  -     appr. nearest neighbors of each query q in Q
%
%                     flag -  whether to display the debug info
%
%  OUTPUT:
%                      nnid   -   indices of appr. nearest neighbors in T
%                      num   -    the corresponding collision count
%

if nargin < 6,
     flag = 0;  % donot display for the debug info
end

D = size(T, 2);
T_n = size(T, 1);   % gallery
%Q_n = size(Q, 1);  %  probe

% the bucket index length
BL = floor(h/3); % (<h)

%the times the random protocol executes the work
m = 3;
% define a cell to store the prime and modulo prime feature
entries = cell(T_n, l); %

% choose uniformly a prime p
prim = getprimes(h, m); % the chosen prime

% Hashing Functions
% l hash functions are defined by randomly choosing h subsets
g = cell(1, l);  
for i = 1 :  l   
       %hash function g is obtained by concatenating h randomly chosen subsets in D
       g{i} = unidrnd(D, 1, h);  % just store the indices here 
end

% store a map in each hash table if only non-empty buckets are stored
for i = 1 : l
    hashtables{i} = containers.Map('KeyType','uint32', 'ValueType','any');  
end

if flag == 1,
    bucketkeys = cell(T_n, l); % just use for the test
end

%%Database Preprocessing
% construct l hash tables, each corresponding to a different hash function g
for i = 1: l
       %for each  hash table
      func = hashtables{i};  %the map in the hash table
       
      r =  g{i};  %the chosen random indices
       
      b = []; %store the entries in the bucket
       
       % hash all vectors from T into each of the L hash tables
       for j= 1 : T_n
                 % for each vector in T
                 v = T(j, :); 
                 bin = v(r);   % the random chosen bucket number as the hash function g
              
                 [ind, s] = secondhash(bin, prim, m); % get the bucket index ind, and the entry s
                  
                  if flag == 1,
                          bucketkeys{j, i} = ind;
                          %entries{j, i} = s;
                  end
                      
                  if  isKey(func, ind), % in the bucket of the hashtable?
                          b = func(ind);
                          
                          func(ind) = unique([b, j]);
                  else
                          func(ind) = j;  %
                  end 
                   
                   %store the prime and modulo prime as bucket entries in the LSH tables
                   entries{j, i} = s;  %store the modulo prime features here

        end  
             
end


%% Query answering algorithm to perform similarity search
%   return the n appr. nearest neighbors for the query vector q
cnt = zeros(T_n, l);
for i = 1 : l  % 
      % for each hashtable
       qr =  g{i}; % the hash functions are applied to the query q
       bin_q = q(qr);   % iterates over the l hash functions g
       
      [key, s] = secondhash(bin_q, prim, m);
       
       func_q = hashtables{i};  % the map function
          
       % all the vectors in the same buckets as q are retrieved as candidates 
       if isKey(func_q, key), 
            % the same bucket
             inds = func_q(key);  %
             
             for ii = 1 : length(inds)
                 ind = inds(ii);
                 
                 % the same entry - consider this as the same 
                 if isequal(s, entries{ind, i}), % get the modulo prime
                       cnt(ind, i) = cnt(ind, i) + 1;
                 end
                 
             end
             
       end      

end

%rank the candidates (only those vectors that collide with q) according to the collision count
[num, nnid] = sort(sum(cnt, 2), 'descend');
if length(nnid) >= n,  %get the first n candidates
       nnid = nnid(1:n);
       num = num(1:n);
end


%% the sub functions
% get the prime array
function p = getprimes(len, m)
     all_ps = primes(len^2);
     nps = length(all_ps);
     pick = randi([2, nps], 1, m);
     
     p =all_ps(pick);
end

% return the natural number for the first BL bit , and module prime s
%based on randomized protocol
function [ind, s] = secondhash(bin, p, ~)
      ind = bi2de(bin(1:BL), 'left-msb');

      de = bi2de(bin(BL+1 : end), 'left-msb');  % map the h binary vector to a natural number
      s = mod(de, p);
end

end