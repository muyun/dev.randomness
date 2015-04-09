function re = kNN(p,  q, k, l)
% TODO: for the options
%function re = findNearNeighbors(p,  q, options)
% check whether the binary vector p is the near neighbors of q ( H(p,q) <= k) with the options
% 
%  re is 
% some ideas borrow from kmean.m
%

% if nargin ~=3 & nargin ~= 4,
%     error('Too many or too few input arguments!');
% end
% 
% % the default options
% default_options = [  
%                                          3 ;        % the num of partitions, should be larger than the hamming distance 
%                                         10;       % max. number of iteration
%                                           2;         % the hamming distance
%                                         1e-6;    %
%                                         1 ];        % info display during iteration
% 
%  if nargin == 3,
%        options = default_options;
%  else
%        % if "options" is not fully specified
%        if length(options) < length(default_options),
%             tmp = default_options;
%             tmp(1:length(options)) = options;
%             options = tmp;
%      end
%      % if some entries of "options" are nan's, replace them with defaults
%      nan_index = find(isnan(options)==1);
%      options(nan_index) = default_options(nan_index);
%      
%  end
% 
%  k = options(1);                      % the hamming distance
% % l = options(2);                       % num of partitions
%  max_iter = options(3);       % max. iteration
%  min_impro = options(4);  % min. improvement
%  display = options(5);          % Display info or not

% Init test parameters
%D =  length(p);
max_iter= 50;
% C controls the stopping criteria
C = (k / length(p)) * l;

% On the 1st layer, split p and q into l  substrings
p_substrings = arraySplit(p, l);
q_substrings = arraySplit(q, l);

% TODO optimize
p_new = {};
q_new = {};

% calculate the unequal number m
m = 0;

% for each substring
for i = 1 :  l
        disp(binaryVectorToString( p_substrings{i} ));
        disp(binaryVectorToString( q_substrings{i} ));

       %check if p_substrings{i} and p_substrings{i} is Inf; 
       %the prime parameter should be larger than one for the accurancy
       [result, err] = randomizedProtocol(binaryVectorToString( p_substrings{i} ), binaryVectorToString( q_substrings{i} ), 1);

        if result ~= 0,  % pi != qi
                 m = m + 1;   
                  %  put it in the new p and q  
                  %  To optimize
                  %p_new = [p_new,  p_substrings{i} ];
                  %q_new = [q_new,  q_substrings{i} ];

                  p_new{m} = p_substrings{i} ;
                  q_new{m} = q_substrings{i} ;
        end
                                
end
                   
%             % check p_new, q_new
%            [result, err] = randomizedProtocol(binaryVectorToString( p_new ), binaryVectorToString( p), 1);
%            if result == 0,  % if p_new == p
%                  r = r + 1;
%                  %
%                   %disp('The num of partitions l should be larger than the hamming distance k');
%                   %break;
%                    findNearNeighbors(p_new,  q_new, k,  l^r);
%            end
            
if m > k,
         % exclude this instance p
         re = 1;

else  % m <= k ,
          % this instance p might be the one we are looking for
          % goto the next layer 
           for iter = 2 : max_iter  % on the 2nd layer now
                 [p_new, q_new, m_new]  = stepknn(p_new,  q_new);  % It might use the different struct to deal with p_new, q_new

                  if m_new > k,
                       re = 1;
                       break;
                  end

                  % if  p_new is the same as p before
                  %
                  if m_new <=  2^iter * C,  % menas that H(p, q) <= k
                        re = 0;
                        break;
                  end

    %          if length(p_new) == 1,
    %                  re = 1;
    %                  break;
    %          end

           end

end

