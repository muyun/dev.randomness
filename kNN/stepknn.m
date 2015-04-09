function [p_new, q_new, m] = stepknn(p, q)
%SETPNEAR   One step in checking that p is in k near neighbors or not in Hamming space to a given query q
%
%         p, q                   -    cell of the binary data
%    p_new, q_new   -    new cells stored the substrings having at least 1-bit error
%                m               -    the number of substrings having at least 1-bit error
%

% The default partition value is 2
l = 2;

% Split the p, q into l substrings on this layer
% p, q is the cell array here
p_substrings = cellSplit(p, l);
q_substrings = cellSplit(q, l);

%
len_ps = length(p_substrings);

% TODO optimize 
p_new = {};
q_new = {};
%p_new = cell(1, l);
%q_new = cell(1, l);

m = 0;

for i = 1 : len_ps
       % for each substring
       disp(binaryVectorToString( p_substrings{i} ));
       disp(binaryVectorToString( q_substrings{i} ));
       
       %check if p_substrings{i} and p_substrings{i} is Inf
        [result, err] = randomizedProtocol(binaryVectorToString( p_substrings{i} ), binaryVectorToString( q_substrings{i} ), 1);

        if result ~= 0,  % pi != qi
                     m = m + 1;  % 
                      %  put it in the new p and q  
                      %  To optimize
                     p_new{m} = p_substrings{i} ;
                     q_new{m} = q_substrings{i} ;                
       end
end

%p_new()= [];

