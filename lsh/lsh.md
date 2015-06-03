####

##### [Locality-Sensitive Hashing (LSH)] [3]
    * LSH is based on the idea that, if two points are close together, then after a ¡°projection¡± operation these two points
     will remain close together.
	 
    * LSH projects the data into a low-dim space; Similar items are mapped to the same buckets with high probability.
	Candidate pairs are those that hash to the same bucket.
	
    LSH drastically reduce the number of distances to be calculated by considering only those vectors that collide with
    the query vector under one or more of the hash functions.

    * Generalized LSH:  Amplify using AND-OR cascades
      ......

    * LSH for Euclidean Distance
    A set of basis functions to start LSH for Euclidean distance can be obtained by choosing random lines and projecting
    points onto those lines [3]. Each line is broken into fixed-length intervals, and the function answers "yes" to a
    pair of points that fall into the same interval.  Nearby points are always close and distant points are rarely in the same bucket. 

    * Exact Euclidean LSH (E2LSH) [4]
	E2LSH package provides a randomized solution for the high-dim near neighbour problem in the Euclidean space.

	
###

[3]: "http://infolab.stanford.edu/~ullman/mmds.html"   "Mining of Massive Datasets"
[4]: "http://www.mit.edu/~andoni/LSH/" "E2LSH"
