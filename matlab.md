### matlab optimization tips

######
  * Vectorization
  
  * [copy-on-write mechanism] [1] transparently allocates a temporary copy of the data only when it sees that the input data is modified.
  
  * [ In-place data manipulation ] [1] means that the original data block is modified rather than creating a new block with the modified data,
  thus saving any memory allocations and deallocations.
  
     - in-place optimization
	 
     - when returning data from a function, we should try to update the original data variable whenever possible, avoiding the need for allocation of a new variable.
     
     - 	 
	 
  * Profiling for Improving performance
  
  * 

#### numeric computations [7]

  
####   

#### reference
[1]: http://undocumentedmatlab.com/blog/internal-matlab-memory-optimizations "Internal Matlab memory optimization"
[2]: http://www.mathworks.com/company/newsletters/articles/accelerating-matlab-algorithms-and-applications.html?s_eid=PSM_8410&utm_content=buffer80dd4&utm_medium=social&utm_source=plus.google.com&utm_campaign=buffer#Performance
     "Accelerating MATLAB Algorithms and Applications"
[3]: https://statinfer.wordpress.com/2011/11/14/efficient-matlab-i-pairwise-distances/#comment-56  "Efficient Matlab"	
[4]: http://gribblelab.org/scicomp/10_Speeding_up_your_code.html   "Speeding up the code"
[5]: http://www.mathworks.com/company/newsletters/articles/accelerating-matlab-algorithms-and-applications.html?s_eid=PSM_8410&utm_content=buffer80dd4&utm_medium=social&utm_source=plus.google.com&utm_campaign=buffer#Performance 
"Accelerating MATLAB Algorithms and Applications"
[6]: http://undocumentedmatlab.com/blog/profiling-matlab-memory-usage/ "Profiling Matlab memory usage"
[7]: http://www.mathworks.com/help/symbolic/digits.html "Variable-precision accuracy"
[8]: http://matlab.cheme.cmu.edu/archive/ "Matlab at CMU"
[9]: http://www.math.mtu.edu/~msgocken/intro/node1.html "Matlab tutorial"
	 
