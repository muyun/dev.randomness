###

#### Find all p in T such that H(p, q) <= k

    #init
	     - a T = N x D dataset of binary strings (uniform)
		 
		 - a query q (1 x D)
		 
		 - a given number k for the hamming distance measure
	
	
	#
	For each instance p in T , and a query q
	
	     #- split the binary code p into m substrings (chunks)     <--- m <= D/(logN - 1)
	     #      p_substrings = split(p, m)
		 #	  
		 #- for each substring pi, qi in { 1 ... m }
		 #
         #      if each substring pi, H(pi, qi) > k' = floor(k/m)   <--- m > k
		 #	       the p is not 
		 #
         - 	split the binary code p, q into l substrings (chunks)     <--- l <= D/(logN - 1)  <--- without evaluating the actual value of H(p,q)
                p_substrings = split(p, l)		 
                q_substrings = split(q, l)
         
		 
		 -  define m as the number of the pi != qi substring based on randomizedProtocol(pi, qi, 1) in { 1... l }
		 
               -if m > k                                              <--- H(p, q) > k
                    the p is not
				end if
                 
               -if m <= k
				    
				    for each unequal substring pi, qi in { 1 ... m } 
					
                	     split the i substring into half              <--- 2m substrings
						    
                         define m1 in the 2m substrings as the number of the pi != qi based on randomizedProtocol(pi, qi, 1)
						 
						     if m1 > k
							    the p is not
								
							 if m1 <= k
							   ...
							   iterate r times until the convergence when mr*(s/2^r) <= k
					
					end for
					
				end if	
		 -	   	
		 
	end For		   

	
####
	
##### TODO: recursion 

