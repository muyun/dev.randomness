function  [s, p] = msgSend(x, m)
% return the binary representations of s and p
%
%    INPUT:
%             x        -    string     ->  a sequence x of n bits in R1,   x = x1 ... xn    
%             m       -     integer  ->  the times the protocol executes the work    
%
%    OUTPUT:  
%          [s, p]   -    R1 sends the binary representation of s = s1 ... sn and p = p1 ... pn to R2
%

%  the len_x bits of x in R1
len_x = length(x); 
% bug here if the len_x is 1 bit
if len_x == 1,
    len_x = 2;
end

%  choose m uniformly random primes here
p = randi([2, len_x^2],  1,  m);

% si = Number(x) mod pi
s =  mod (bin2dec(x),  p) ;

% for the binary representations (not the string representations here) in the message
s = decimalToBinaryVector(s);
p = decimalToBinaryVector(p);
%s  = dec2bin(s);
%p = dec2bin(p);
