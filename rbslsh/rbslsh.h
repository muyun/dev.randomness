/**
 *  @file rbslsh.h -
 * 
 *  @brief  Locality-Sensitive Hashing Scheme based on Random Bits Sampling
 *          Some code thinking borrows from the cylinderCodeApp and LSHBOX
 *
*/

#pragma once
#include <iostream>
#include <fstream>
//#include <map>
/*  unordered_map containers are faster (because hash is O(1), binary search tree is O(logn) )
than map containers to access individual elements by their key, although they are generally less efficient
for range iteration through a subset of their elements
*/
#include <unordered_map>
#include <vector>
#include <set>	    //"sorted, unique" container
#include <random>	// the random number lib
#include <functional>
//#include <math.h>
#include <cmath>

namespace lsh{
	class rbslsh 
	{
	public:
       struct Parameter {	
		   unsigned L;	 // number of hash tables
		   unsigned H;	 //	the width parameter
		   unsigned K;	 //	appr. nearest neighbors of the query q

		   unsigned M;	 // hash table size, number of buckets

		   unsigned D;	 // dimension of the vector
		   unsigned N;   // size of the vectors

		} param;

	private:
		//Parameter param;
		//  chosen random H sequence in each hashtable
		std::vector<std::vector<unsigned>> seqs;

		// store the bucket entries in each hashtable
		std::vector<std::vector<unsigned>> buckets;

		// map hashcode to the bucket entries in each hashtable
		std::vector<std::unordered_map<unsigned, std::vector<unsigned> >> hashtables;

	public:
		rbslsh() {}
		rbslsh(const Parameter& param_){
			param.L = param_.L;
			param.H = param_.H;
			param.K = param_.K;

			param.N = param_.N;
			param.D = param_.D;

			param.M = param_.M;
			
			// init
			Init();
		}
		/*
		rbslsh(int l, int h, int k, int n, int d) {
			param.L = l;
			param.H = h;
			param.K = k;

			param.N = n;
			param.D = d;

			//¦Á = N/M
			param.M = ceil(param.N / ¦Á);

			// init
			Init();
		}*/

		~rbslsh() {}

		//Init hashtable
		void Init(){
            // uniform distribution
			std::random_device rd;
			std::mt19937 rng(rd());
			//std::mt19937 rng(unsigned(std::time(0));
			
			// the the random index
			seqs.resize(param.L);
			std::uniform_int_distribution<unsigned> rndbit(0, param.D - 1); 
            for (std::vector<std::vector<unsigned>>::iterator iter = seqs.begin(); iter != seqs.end(); ++iter){
			   	//each hash table

				// choosing the first h in D
				//std::cout << "The chosen random dim:" << std::endl;
				for (unsigned i = 0; i != param.H; ++i){
					//the chosen random dim
					unsigned dim = rndbit(rng);
					//std::cout << dim << " ";

					//store the chosed random index here
					iter->push_back(dim);
				}
				//std::cout << std::endl;
            }

			//the buckets in each hash table
			buckets.resize(param.L);
			std::uniform_int_distribution<unsigned> rndbucket(0, param.M - 1);
			for (std::vector<std::vector<unsigned>>::iterator iter = buckets.begin(); iter != buckets.end(); ++iter){
				// in each hash table

				for (unsigned i = 0; i != param.M; ++i){
					 //in each bucket
					unsigned buk = rndbucket(rng);
					//std::cout << buk << " ";

					iter->push_back(buk);
				}
				//std::cout << std::endl;
			}

			//
			hashtables.resize(param.L);

        }

		// Reset the default parameters
		void Reset(const Parameter &param_){
			param = param_;
			//hashtables.resize(param.L);
			//seqs.resize(param.L);
			//buckets.resize(param.L);

			// init
			Init();
		}

		
		/* 
		 * Insert the hashcode key into each of the L hash tables
		 * 
		 * @param  ind	- the index
		 * @param  domain - the vector
		*/
		template <typename T>
		void Insert(unsigned ind, std::vector<T> domin){ //The reference not direct value here might be better
			for (unsigned i = 0; i != param.L; ++i){
				// in each hash tables
				unsigned result(0);

				//get the bucket based on the hashcode
				for (std::vector<unsigned>::iterator iter = seqs[i].begin(); iter != seqs[i].end(); ++iter)  
				{
				  //
					result = (result << 1);
					//std::cout << *iter << std::endl;
					//std::cout << domin[*iter] << std::endl;

					result = (result | (unsigned)(domin[*iter] - '0')); // bool not unsigned char here will be better
				}
                unsigned hashcode = result % param.M;  //Hash table size M

				// all the vector in the same bucket are retrieved as candidates
				hashtables[i][hashcode].push_back(ind);	 //unordered maps support the direct access operator[]
			}
		}

		/* Query to perform similarity search
       	 * return the n appr. nearest neighbors for the query q
		 *
		 * @param  domain - the vector
	     */
		template <typename T>
		void Query(std::set<unsigned>& sinds, std::vector<T> domin){
			std::vector<unsigned> inds;	//store the candidates

			for (unsigned i = 0; i != param.L; ++i)
			{
				// in each hash table
				unsigned result(0);

				// get the hashcode
				for (std::vector<unsigned>::iterator iter = seqs[i].begin(); iter != seqs[i].end(); ++iter)
				{
					//
					result = (result << 1);
					//std::cout << *iter << std::endl;
					//std::cout << domin[*iter] << std::endl;

					result = (result | (unsigned)(domin[*iter] - '0')); // bool not unsigned char here will be better
				}
                unsigned hashcode = result % param.M;

                if (hashtables[i].find(hashcode) != hashtables[i].end())
				{
					//in the same bucket as the candidates
					for (std::vector<unsigned>::iterator iter = hashtables[i][hashcode].begin(); iter != hashtables[i][hashcode].end(); ++iter)
					{
						//in the vector
						//std::cout << (*iter) << std::endl;
						// insert the unique ind
						inds.push_back(*iter);
					}
				} //if
			}

			/*
			// remove the duplicated one
			std::set<unsigned> sinds(inds.begin(), inds.end());
			inds.assign(sinds.begin(),sinds.end());
			*/

			// rank the candidates indices
			for (std::vector<unsigned>::iterator iter = inds.begin(); iter != inds.end(); ++iter){
				unsigned max = std::count(inds.begin(), inds.end(), *iter);
				unsigned id = *iter;

				// find the max
				for (std::vector<unsigned>::iterator iter1 = iter + 1; iter1 != inds.end(); ++iter1){
					int cnt = std::count(inds.begin(), inds.end(), *iter1);
					if (cnt > max){
						max = cnt;
						id = *iter1;
					}
				}

				sinds.insert(id);
			}

			//return inds;
		}

		// save the result to the file
		template <typename T>
		void Save(const std::string& filename, std::set<T>& inds){
			unsigned i, j;

			/*
			fout = fopen(filename, "w");
			if (!fout) {
			printf("Cannot open output file.\n");
			exit(1);
			} */

			std::ofstream file(filename, std::fstream::app|std::fstream::out);
			unsigned k = 0;
			if (file.is_open()){
				//
				for (std::set<T>::iterator iter = inds.begin(); iter != inds.end(); ++iter){
					++k;
					if (k > param.K){
						break;
					}

					std::cout << *iter << ",";
					file << *iter <<",";
                }
				std::cout << std::endl;
				file << std::endl;

				file.flush();
			}

			file.close();
		}

		// load the model
		void Load(const std::string& file){
		}

	};
}
