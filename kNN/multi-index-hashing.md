  ###
  
  ####  randomizedProtocol
  
  ####  [ Extended randomizedProtocol ] [1] -  Output x ~ y if the two binary codes x and y differ by r bits or less
  
        #init
		     - the input binary code (x, y)

			 - the hamming distance r
			      => 
			      => at least one substring is guaranteed to have r' = floor(r / m) or less bit equal


             - hash_tables = a list of m hash tables 	
			 
		end init
		

        # add x into the associated hash table under the index x_str

             - split the binary code x into m substrings (chunks)
                   x_substrings = split (x, m)
        
	    	 - for each substring i in { 1 ... m }
		
		           hash_table = hash_tables[i]
			       x_str = x_substrings[i]
             
			       x_substring_list = hash_table{x_str}   # index
			       x_substring_list.append(x)      # entry
		     
		       end for
		
		
		# lookup
             - split the binary code y into m substrings
                   y_substrings = split(y, m)
        
     		 - for each substring i in { 1 ... m }
		
		          if in the substring y_str, the hamming distance r(y_str) > r'
			         x != y
			 
       	 		  next:	   		 
        		 ( one solution is the recursion alg, the ending condition is the substring y_str == 1 bit )
			 
		    	  [ LshTable ] [2]
    			  Look up the associated hash table for a y_substring that's close (zero or one bits off)
			      
				  TODO:
				  
               end for		
		
				 
[1]: https://engineering.eventbrite.com/multi-index-locality-sensitive-hashing-for-fun-and-profit/ "Multi-Index-LSH"
[2]: Fast Search in Hamming Space with Multi-Index Hashing "Multi-Index Hashing"	


		 
