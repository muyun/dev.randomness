###
  
#### the implementation of LSH approach

	 - project a binary vector v into a subspace with h dimensions (h < n), 
	   selecting a subset of h bits from the n bits in v .
	   
	   
##### Prepocessing
Input:
     - a dataset of binary strings
	 
	 - a query q
	 
	 - l hash functions {f1, f2, ... fl}
	       the hash function f maps a binary vector to the natural number
	  
Output:
     - l Hash tables H in {H1, H2, ... Hl}

	 
Foreach i = 1, ..., l
     #Initialize hash tables H by generating a random hash function f(.)
	 
End Foreach	 
	
Foreach vector v in the dataset 
   
   Foreach hash function fi in {f1, f2, ... fl}
         
         b = f(v)
		 store the index of v in bucket b of table T(i)
   
   End Foreach
 
End Foreach 


######To include the prime feature, 
modify the LSH algorithm by creating prime and modulo prime from the last few bits and store them as bucket entries in the LSH tables
    