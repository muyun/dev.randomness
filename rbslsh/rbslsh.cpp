/* 
 *  @file rbslsh.cpp : test the lsh
 *
 *  @author: wenlong
*/

#include "stdafx.h"
#include "matrix.h"
#include "rbslsh.h"
#include <vector>

/*
template <typename T>
void read_points(std::vector<std::vector<T>>& matrix, std::string& path, unsigned rows, unsigned cols)
{
	std::ifstream file(path);
	if (!file){
		std::cout << "Cannot open input file." << std::endl;
		return;
	}

	std::vector<T> points;
	T point;
	//unsigned i = 0;
	//unsigned row = 0;
	while (file >> point){

		//file >> point;
		//std::cout << point << std::endl;
		points.push_back(point);
	}
	//points.push_back('\0');

	file.close();

	std::vector<uchar>::iterator iter = points.begin();
	for (unsigned i = 0; i != rows; ++i){
		unsigned ind = i * cols;	  // each row

		//std::vector<uchar> row(iter + ind, iter + ind + cols);

		for (unsigned j = 0; j != cols; ++j){
			//matrix[i][j] = row[j];
			matrix[i][j] = points[ind + j];
			std::cout << matrix[ind][j] << " ";
		}
		std::cout << "\n";
	}

}
*/

template <typename T>
void write_results(std::vector<std::vector<size_t>>& points, const std::string& filename, int rows, int cols)
{
	//FILE* fout;
	//int* p;
	unsigned i, j;

	/*
	fout = fopen(filename, "w");
	if (!fout) {
	printf("Cannot open output file.\n");
	exit(1);
	} */
	std::ofstream file(filename);

	if (file.is_open()){

		for (i = 0; i < rows; ++i) {
			for (j = 0; j < points[i].size(); j++) {
				file << points[i][j] << " ";
				//cout << points[i][j] << " ";
			}
			//cout << endl;
			file << std::endl;
			file.flush();
		}
	}

	file.close();
	//fclose(fout);
}


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

	/*
	for (unsigned i = 0; i != rows; ++i){
		//int ind = i * cols;
		//std::cout << dataset[i][] << std::endl;

		//std::vector<unsigned char>	vec(dataset[i],dataset + sizeof(dataset)/sizeof);
		//std::cout <<"hello"<< std::endl;

		//std::vector<unsigned char> row;
		
		for (unsigned j = 0; j != cols; ++j){
			unsigned y = ind + j;
			//row.push_back(dataset[y]);
			//std::cout << dataset[ind + j];
		}
		
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
	//Todo, using the gallery data source
	int num = 5;
	std::set<unsigned> inds;
	for (unsigned ind = 0; ind != num; ++ind){
		mylsh.Query(inds,dataset[ind]);
	
        //display
		std::cout << "The first " << param.K <<  " neighbors for the query : " << ind <<std::endl;
		unsigned k = 0;
	    for (std::set<unsigned>::iterator iter = inds.begin(); iter != inds.end(); ++iter){
		   std::cout << (*iter) << " ";

		   k++;
		   if (k > param.K){
			   break;
		   }
	    }
	    std::cout << std::endl;

		//clear
		inds.clear();
	}

	// write the file

	return 0;
}

