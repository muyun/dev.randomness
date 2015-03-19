clear, clc;
% An implementation of the Randomized Protocol for Equality .
%  It answers to the question that whether "x = x1 ... xn" (the database in R1) and  "y = y1 ... yn" (the one in R2) are equal with  an error
% probability (By default, the input is "x != y") .
% 
% 
% INPUT:
%       (x,  y)  -  The database in bits string
%
% OUTPUT:
%         err    -  The reliability ( error probability) of the randomized protocol R = (R1, R2) for the input (x,  y)
%                       err = ( ln(n^2) / n ) ^m
%
% PARAMETER:
%           m     -  Set the times the protocol executes the work, always with an independent, new choice of a prime
%

%  init
%  m uniform primes
m = 10;

% In the case, set x != y
% the test database in bits in R1
x = '011111110011111110011111110011111110';
% the test database in bits in R2
y = '101101110011111110011111110011111110';
%y = x;

% init the size of the resizing array
%num = ceil(n / 100);

[result, err] = randomizedProtocol(x,  y,  m);

if result == 0
    disp( 'The answer:  x = y  ');
    
end    

if result ==1
    disp('The answer:  x != y  ');    
    
end

g = sprintf('%0.3f ', err);
fprintf('The error probability:  %s\n',  g);

% %outputs "x = y" for different x and y
% index = q == bin2de(s);
% if (length( find(index ==0) ) ) == 0  % if qi = si for all i in 1 ... n
%        disp(' x == y ');
%            
%         % get the bad prime for input (x, y)
%        p = bin2de(p);
%        z = arrayResize(n, p);
%        
% else
%        disp(' x ~= y ');
%         
%        z = zeros(1, n);
% end
% 

