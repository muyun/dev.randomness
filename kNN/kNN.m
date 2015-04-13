function [re, iter] = kNN(p,  q, k, l, options)
% check whether the binary vector p is the near neighbors of q ( H(p,q) <= k) with the options
% 
% INPUT:
%       p, q                  -   the binary vector p, and the query q
%          k                    -   the hamming distance
%          l                     -   the partition number
%
%      options(1)    -    max. number of iteration (default: 100)
%      options(2)    -    info display during iteration (default: 0)
%
% OUTPUT:
%           re                 -    [0, 1] (0 means that p is the k nearneighbor of q; 1 is not)
%           iter              -   the interation num to get the instance p
%

if nargin ~=4 && nargin ~= 5,
    error('Too many or too few input arguments!');
end

% the default options
default_options = [     100;         % max. number of iteration
                                             0 ];         % info display during iteration

 if nargin == 4,
       options = default_options;
 else
       % if "options" is not fully specified
       if length(options) < length(default_options),
            tmp = default_options;
            tmp(1:length(options)) = options;
            options = tmp;
      end
     % if some entries of "options" are nan's, replace them with defaults
     nan_index = find(isnan(options)==1);
     options(nan_index) = default_options(nan_index);
     
 end

 max_iter = options(1);       % max. iteration
 display = options(2);          % Display info or not

% Init test parameters
%D =  length(p);
%max_iter= 10;
% C controls the stopping criteria
C = (k / length(p)) * l;

% On the 1st layer, split p and q into l  substrings
p_substrings = arraySplit(p, l);
q_substrings = arraySplit(q, l);

p_new = {};
q_new = {};
%p_new = cell(1, l);
%q_new = cell(1, l);

% calculate the unequal number m
m = 1;
iter = 1;

% for each substring
for i = 1 :  l
        %disp(binaryVectorToString( p_substrings{i} ));
        %disp(binaryVectorToString( q_substrings{i} ));

       %check if p_substrings{i} and p_substrings{i} is Inf; 
       [result, err] = randomizedProtocol(binaryVectorToString( p_substrings{i} ), binaryVectorToString( q_substrings{i} ), 1);

        if result ~= 0,  % pi != qi
                  %  put it in the new p and q  
                  %  To optimize
                  %p_new = [p_new,  p_substrings{i} ];
                  %q_new = [q_new,  q_substrings{i} ];

                  p_new{m} = p_substrings{i} ;
                  q_new{m} = q_substrings{i} ;
                  
                  m = m + 1;  
        end
                                
end

%remove the empty cell
%p_new(m : l)= [];
%q_new(m : l)= [];
                   
%             % check p_new, q_new
%            [result, err] = randomizedProtocol(binaryVectorToString( p_new ), binaryVectorToString( p), 1);
%            if result == 0,  % if p_new == p
%                  r = r + 1;
%                  %
%                   %disp('The num of partitions l should be larger than the hamming distance k');
%                   %break;
%                    findNearNeighbors(p_new,  q_new, k,  l^r);
%            end
            
if (m-1) > k,
         % exclude this instance p
         re = 1;

else  % m <= k ,
          % this instance p might be the one we are looking for
           for iter = 2 : max_iter  % on the 2nd layer now
                % goto the next layer 
                 [p_new, q_new, m_new]  = stepknn(p_new,  q_new);  % It might use a different struct to deal with p_new, q_new

                 if display,
                       fprintf('Iteration %d\n', iter);
                 end
                 
                 % check termination condition
                  if m_new > k,
                       re = 1;
                       break;
                  end

                  % if  p_new is the same as p before
                  %
                  if m_new <=  2^iter  *  C,  % menas that H(p, q) <= k
                        re = 0;
                        break;
                  end

    %          if length(p_new) == 1,
    %                  re = 1;
    %                  break;
    %          end

           end

end

