function q = msgReceive(y, p)
% return the number q on R2
% 
%    INPUT:
%             p  -   the binary representation from R1  
%             y  -   the database on R2
%
%    OUTPUT:  
%             q   -  After reading s = s1 ... sn and p = p1 ... pn in binary representations,  R2 computers the number q = q1 ... qn
%

%  the n bits of x in R1
%n = length(y);

% choose uniformly a prime p at random
%p = randi([2, n^2], 1, 1);

% q is a decimal vector here
q =  mod (bin2dec(y),  binaryVectorToDecimal(p));

