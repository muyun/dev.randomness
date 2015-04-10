
## The Introduction  
   This is an implementation of the Randomized Protocol for Equality.
  
   It answers to the question that whether "x = x1 ... xn" (the database in R1) and  "y = y1 ... yn" (the one in R2) are equal with an error probability (By default, the input is "x != y") .
   

##  The Parameters
    %
    % INPUT:
    %       (x, y)  -  The database in bits string
	%          m    -  Set the times the protocol executes the work, always with an independent, new choice of a prime
    %
    % OUTPUT:
    %         err    -  The reliability ( error probability) of the randomized protocol R = (R1, R2) for the input (x, y)
    %                       err = ( ln(n^2) / n ) ^m
    %

    
##  The TEST result
    
    The input:
    %   x = '011111110011111110011111110011111110'
	%   y = '101101110011111110011111110011111110'
	%   m = 10
	
	The output:
	  The answer:  x != y  
      The error probability: 0.000  
      >> 