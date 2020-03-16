  
#### Randomness as a source of efficiency 
* Randomization of a part of the control is an essential concept of nature’s strategy  
* 
* Using randomization one can gain phenomenally in the efficiency by paying a very small price in reliability.  
* A fast randomized algorithm can be more reliable than a slow deterministic algorithms.  
 
#### lsh algorithm
* LSH based on Random Bits Sampling

#### our kNN algorithm
* Find k Near Neighbors in hamming distance without evaluating the actual value of this hamming distance.
* The above Randomness alg is used.

* rbslsh
  - an implementation in C++   

##### matlab.md - matlab coding tips     
* Vectorization  

* [copy-on-write mechanism] 1 transparently allocates a temporary copy of the data only when it sees that the input data is modified.

* [ In-place data manipulation ] 1 means that the original data block is modified rather than creating a new block with the modified data, thus saving any memory allocations and deallocations.
  - in-place optimization  
  - when returning data from a function, we should try to update the original data variable whenever possible, avoiding the need for allocation of a new variable.  

* Profiling for Improving performance


* numeric computations
