/* 
 *  @file rbslsh.cpp : test the lsh
 *
 *  @author: wenlong
*/

#include "stdafx.h"
#include "matrix.h"
#include "rbslsh.h"

int main(int argc, char** argv[])
{
	//init
	//unsigned rows = 4;
	//unsigned cols = 11;
	unsigned rows = 200;
	unsigned cols = 448;

	//load the data
	std::string path = "E:\\wenlong\\documents\\proj\\thecode\\rbslsh\\data\\gallery.dat";
	std::cout << "Load the data ..." << std::endl;
	
	lsh::Matrix<bool> dataset;	//binary code
	// load the data in matrix 
	dataset.load(path, rows, cols);

	/*
	// print the data
	std::vector<bool> row;
	for (unsigned i = 0; i != rows; ++i){
		//dims[i] = new std::vector<T>(_dim);
        row = dataset[i];
			
		for (unsigned j = 0; j < row.size();j++){
			std::cout << row[j];
		}
		std::cout << std::endl;
	}
	*/

	// L - number of hash tables
	// H - the width parameter
	// K - appr. nearest neighbors of each query q in Q

	float ¦Á = 0.7;	// ratio ¦Á = N / M,
	lsh::rbslsh::Parameter param;
	param.L = 12;
	param.H = 7;
	param.K = 5;  // the first 
	
	param.N = dataset.getSize();
	param.D = dataset.getDim();
	param.M = ceil(param.N / ¦Á);   // M buckets

	lsh::rbslsh	mylsh(param);
	//mylsh.Init();

	// Insert
	for (unsigned ind = 0; ind != dataset.getSize(); ++ind){
		//each vector
		mylsh.Insert(ind, dataset[ind]);
	}

	// Query
	//TODO, using the gallery data source
	std::string result = "E:\\wenlong\\documents\\proj\\thecode\\rbslsh\\data\\result.dat";
	
	int num = 5;
	std::set<unsigned> inds;
	for (unsigned ind = 0; ind != num; ++ind){
		mylsh.Query(inds,dataset[ind]);
	
        //display
		std::cout << "The first " << param.K <<  " neighbors for the query " << ind <<std::endl;
		
		//Write the file
		mylsh.Save(result, inds);

		//clear
		inds.clear();
	}

	return 0;
}

