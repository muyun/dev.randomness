function [result,  err] = randomizedProtocol(bin_x,  bin_y, m)
%  randomizedProtocol      is a communication protocol between R1 and R2
%  that is able to determine whether the data saved on both computers is the same or not .
%
%  INPUT:
%         bin_x   -    string(default)    -> a sequence x of n bits on R1,   x = x1 ... xn         
%         bin_y   -    string(default)    -> a sequence y of n bits on R2,   y= y1 ... yn
%         m       -      integer          ->  the times the protocol executes the work, always with an independent, new choice of a prime
%
%  OUTPUT:
%      result          -   [0, 1]  (1 means "x = y"; 0 is not)
%      err             -   err = ( ln (n^2) / n ) ^m                                          
%
%   Date:  March 19, 2015
%

% the test database
%x = '01111';
%y = '10110';  

if nargin < 3
    m = 1;
end
err = [];

%  R1 sends the binary representations of si and pi to R2
%  R1 can choose m uniformly random primes  
%n = max(length(bin_x), 2); % bug here if the len_x is 1 bit
n = length(bin_x);

%  choose m uniformly random primes here
%if n == 1 % 1 bit
if n < 5,
    if isequal(bin_x, bin_y)
        result = 1;
    else
        result = 0;
    end
    err = 0;
else    
    all_ps = primes(n^2);
    nps = length(all_ps);
    pick = randi([2, nps], 1, m);  %get the uniformly random indexes
    p = all_ps(pick);
    
    % x must represent a nonnegative integer value smaller than or equal to 2^52
    x = bi2de(bin_x);
    s =  mod (x,  p) ;
    
    %  After reading s = s1 ... sn and p = p1 ... pn, R2 computers the q = q1 ... qn
    %% q = msgReceive(y, p);
    y = bi2de(bin_y);
    q =  mod (y,  p);
    
    %% Check the number of  si = qi for all i in {1 ... n}
    %if (length( find(index ==0) ) ) == 0  % if qi = si for all i in {1 ... n}
    if isequal(s, q)
        %disp(' x = y ');
        result = 1;
    else
        %disp(' x != y ');
        result = 0;
    end
    
    % Estimate error
    % The reliability ( error probability) of the randomized protocol R = (R1, R2) for the input (x, y)
    % approximation from the book
    err = ( log(n^2) / n )^m;   %  err = ( ln(n^2) / n ) ^m
end