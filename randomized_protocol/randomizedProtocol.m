function [result,  err] = randomizedProtocol(x,  y, m)
%  randomizedProtocol      is a communication protocol between R1 and R2
%  that is able to determine whether the data saved on both computers is the same or not .
%
%  INPUT:
%         x             -    string(default)    -> a sequence x of n bits on R1,   x = x1 ... xn         
%         y             -    string(default)    -> a sequence y of n bits on R2,   y= y1 ... yn
%         m             -      integer          ->  the times the protocol executes the work, always with an independent, new choice of a prime
%
%       NOTICE:  The protocol doesnot give very high accuracy (~75%) for the short sequence bits ( n < 4)
%  
%  OUTPUT:
%      result          -   [0, 1]  (0 means "x = y"; 1 is not)
%      err             -   err = ( ln (n^2) / n ) ^m                                          
%
%   The complexity:
%   The only communication of the protocol involves submitting the binary representations of the positive integers s and p .
%    s<= p <n^2, hence the length of the message is at most  2 * ( log(n^2) / log2) ) <= 4 * ( log(n) / log2 )
%
%   Date:  March 19, 2015
%

% the test database
%x = '01111';
%y = '10110';  

%  R1 sends the binary representations of si and pi to R2
%  R1 can choose m uniformly random primes
[s , p] = msgSend(x,  m);

%  After reading s = s1 ... sn and p = p1 ... pn, R2 computers the q = q1 ... qn
q = msgReceive(y, p);
z = [];
%z = binaryVectorToDecimal(p); % z stores the n bad primes for input (x, y)

% Check the number of  si = qi for all i in {1 ... n}
index = q == binaryVectorToDecimal(s);
if (length( find(index ==0) ) ) == 0  % if qi = si for all i in {1 ... n}
      %disp(' x = y ');
        
      % get the n bad primes for input (x, y)
       %z = arrayResize(p, n);
       
       result = 0;
else
       %disp(' x != y ');
        z = binaryVectorToDecimal(p); % z stores the n bad primes for input (x, y)
        
       result = 1;
end

% The reliability ( error probability) of the randomized protocol R = (R1, R2) for the input (x, y)
len =  length(find(z > 0));
if len > 0,
         len_x = length(x);
         if len_x == 1,
             len_x = 2;
         end
         
         if len_x > 8, % n >= 9
             err = ( log(len_x^2) / len_x )^m;   %  err = ( ln(n^2) / n ) ^m
             
         else
             err = m / length(primes(len_x^2));  %  err = (n-1) / Prim(n^2)
        end
    
else
    err = 0;
end
