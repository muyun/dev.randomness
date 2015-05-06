function [re, iter] = kNN(p, q, k, l, max_iter)
% check whether the binary vector p is the near neighbors of q ( H(p,q) <= k) with the options
% 
% INPUT:
%       p, q              -   the binary vector p, and the query q
%          k              -   the hamming distance
%          l              -   the partition number;  (For the variable-precision in matlab,  floor(length(p) / l) + 1 <= 29 )
%
%       max_iter          -   max. number of iteration (default: 100) 
%
% OUTPUT:
%           re            -   [1, 0] (1 means that p is the k nearneighbor of q; 0 is not)
%           iter          -   the interation num to get the instance p
%
 
if nargin < 5,
   max_iter = 100;
end

iter = 1;
% On the 1st layer, split p and q into l  substrings
p_substrings = arraySplit(p, l);
q_substrings = arraySplit(q, l); 
[p_new, q_new, m] = stepknn(p_substrings, q_substrings, l); 

%m = length(p_new);
if m == 0 % p = q  
    re = 1;    
elseif m > k, % p is not in NN(q)
    re = 0;
else  % m < k, p may be in NN(q)
    % this instance p might be the one we are looking for
    % goto the next layer
    for iter = 2 : max_iter  % on the 2nd layer now
        % Create smaller segments by dividing each unequal cell by half
        p_substrings = cellSplit(p_new, 2);
        q_substrings = cellSplit(q_new, 2);
        [p_new, q_new, m_new] = stepknn(p_substrings, q_substrings, 2);         
        % check termination condition 
        if m_new > k,
            re = 0;
            break;
        end
        % m<=k
        if isempty(p_new),
            len_p_new = 0;
        else
            len_p_new = length(p_new{1}); 
        end
        % if m <  2^iter  *  C,  % H(p, q) <= k
        if (m_new*len_p_new <= k) 
            re = 1;
            break;
        end
    end 
end
        
function [p_new, q_new, m] = stepknn(p, q, l)
%SETPNEAR   One step in checking that p is in k near neighbors or not in Hamming space to a given query q
%
% p, q           -    cell of the binary data
% p_new, q_new   -    new cells stored the substrings having at least 1-bit error
%

len_ps = numel(p);
np = 10; % number of primes selected for matching
p_new = {};
q_new = {};
% m    -    the number of substrings having at least 1-bit error
m = 0;  % the index in matlab starts from 1
for i = 1 : len_ps
    % for each substring
    [res, err] = randomizedProtocol(p{i}, q{i}, np);
%      if isequal(p{i}, q{i}),
%          res = 0;
%      else
%          res = 1;
%      end
    if res == 0,  % pi != qi
        m = m+1;
        %  put it in the new p and q
        p_new{m} = p{i} ;
        q_new{m} = q{i} ;        
    end
end