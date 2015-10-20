
/**
* @file matrix.h - 

* @brief Dataset management class
*/

#pragma once
#include <fstream>
#include <sstream>
#include <vector>
#include <string>
#include <assert.h>


namespace lsh
{
	/**
	* Dataset management class. A dataset is maintained as a matrix in memory.
	*
	* The file contains N D-dimensional vectors of <T> point numbers.
	*
	* Such files can be accessed using lsh::Matrix<T>.
	*/
	template <class T>  // class templates allows classes to have members that use template parameters as types
	class Matrix
	{
		int dim;
		int N;
		//T *dims;
		std::vector<std::vector<T>> matrix;
	public:
		/**
		* Reset the size.
		*
		* @param _dim Dimension of each vector
		* @param _N   Number of vectors
		*/
		void reset(int _dim, int _N)
		{
			dim = _dim;
			N = _N;
			/*
			if (dims != NULL)
			{
				delete[] dims;
			}
			*/
			//dims = new T[dim * N];
		
           for (unsigned i = 0; i < N; i++){
				std::vector<T> row;

				for (unsigned j = 0; j < _dim; j++){
					row.push_back(0);

				}
				matrix.push_back(row);
            }
		}

		void free(void)
		{
			dim = N = 0;
			/*
			if (dims != NULL)
			{
				delete[] dims;
			}
			dims = NULL;
			*/
			matrix.clear();
		}

		Matrix() : dim(0), N(0) {}
		Matrix(int _dim, int _N)
		{
			reset(_dim, _N);
		}

		~Matrix()
		{
			/*
			if (dims != NULL)
			{
				delete[] dims;
			}
			*/

			//needn't to clear, automatically
			//matrix.clear();
		}
		
		/**
		* Access the ith vector.
		*/
		/*
		const T *operator [] (int i) const
		{
			return dims + i * dim;
		}
		*/
		/**
		* Access the ith vector.
		*/
		/*
		T *operator [] (int i)
		{
			return dims + i * dim;
		}*/

		std::vector<T> operator[]( int i) const
		{
			/*
			std::vector<T> row;

			for (unsigned j = 0; j < dim; ++j){
				row.push_back(matrix[i][j]);
					//std::cout << points[i*_dim + j] << " ";
					//matrix[i][j] = points[i*_dim + j];
					//std::cout << matrix[i][j] << " ";

				//std::cout << "\n";
			}

            return row;
			*/

			//std::vector<T> row = matrix[i];
			//return row;
			
			//return 	reinterpret_cast<T*>(dims + i*dim);

			return 	matrix[i];
		}

		/**
		* Get the dimension.
		*/
		int getDim() const
		{
			return dim;
		}
		/**
		* Get the size.
		*/
		int getSize() const
		{
			return N;
		}


		/**
		* Load the Matrix from a binary file.
		*/
		/*
		void load(const std::string &path)
		{
		std::ifstream is(path.c_str(), std::ios::binary);
		unsigned header[3];
		assert(sizeof header == 3 * 4);
		is.read((char *)header, sizeof header);
		reset(header[2], header[1]);
		size_t sz = sizeof(T) * dim * N;
		is.read((char *)dims, sz);
		}
		*/

		/*
		* Load the Matrix from a text file
		* @param _N   Number of vectors
		* @param _dim Dimension of each vector
		*/
		void load(const std::string& path, int _N, int _dim){
			//allocate the memory
			reset(_dim, _N);

			//std::string line;

			std::ifstream file(path);
			if (!file){
				std::cout << "Cannot open input file." << std::endl;
				return;
			}

			/*
			//reset(_dim, _N);
			//std::vector<std::vector<T>> points;
			std::vector<T> points;
			T point;
			while (std::getline(file, pointline)){
			//

			std::vector<T> vec(line.begin(), line.end());
			vec.push_back('\0');
			std::cout <<"line: " + line << std::endl;

			std::vector<T> row;
			for (std::vector<T>::iterator iter = vec.begin(); iter < vec.end() - 1; ++iter){
			std::cout << *iter << std::endl;
			row.push_back(*iter);
			}

			for (unsigned i = 0; i < row.size(); ++i){
			std::cout << row[i];
			//dims[i] = vec[i];
			}
			std::cout << std::endl;

			// wrong
			//dims[i]  = &vec;

			// ith vector
			points.push_back(row);

			//dims[i] = vec.data();

			//
			std::cout << point << std::endl;
			points.push_back(point);
			}
			*/
			//std::vector<std::vector<T>> points;
			//vector<T> vec;
			/*
			for (unsigned i = 0; i < _N; ++i){
			for (unsigned j = 0; j < _dim; ++j){
			file >> dims;
			//file >> vec.push_back();
			}
			} */

			//dims = new T[dim * N];

			std::vector<T> points;
			T point;
			//unsigned i = 0;
			//unsigned row = 0;
			while (file >> point){

				//file >> point;
				//std::cout << point << std::endl;
				points.push_back(point);

                /*
				unsigned mod = i % _dim;
				if (mod == 0){
					dims[row] = new vector<T>(_dim);
					//row++;
				}

				// each row
				//unsigned mod_ = i % _N;
				dims[row].push_back(point);

				/*
				int ind = i * _dim;

				unsigned mod = i % _dim;
				if (mod == 0){  // each row
				std::vector<T> row;
				row.push_back(point);
				}

				//
				dims[i] = row;

				points.push_back(row);

				
				i++;
				*/
				
            }
			//points.push_back('\0');

			file.close();

			/*
			// print the data
              
			for (unsigned i = 0; i < _N * _dim; ++i){
				//std::cout << points[i] << std::endl;
				dims[i] = points[i];
			}
			*/

			for (unsigned i = 0; i < _N; ++i){
				//dims[i] = new std::vector<T>(_dim);
                for (unsigned j = 0; j < _dim; ++j){
					//std::cout << points[i*_dim + j] << " ";
					matrix[i][j] = points[i*_dim + j];
					//std::cout << matrix[i][j] << " ";
				}
				//std::cout << "\n";
			}
        }

		/**
		* Load the Matrix from std::vector<T>.
		*
		* @param vec  The reference of std::vector<T>.
		* @param _N   Number of vectors
		* @param _dim Dimension of each vector
		*/
		void load(std::vector<T> &vec, int _N, int _dim)
		{
			reset(_dim, _N);
			for (unsigned i = 0; i != vec.size(); ++i)
			{
				dims[i] = vec[i];
			}
		}
		/**
		* Load the Matrix from T*.
		*
		* @param source The pointer to T*.
		* @param _N     Number of vectors
		* @param _dim   Dimension of each vector
		*/
		void load(T *source, int _N, int _dim)
		{
			reset(_dim, _N);
			for (unsigned i = 0; i != _N * _dim; ++i)
			{
				dims[i] = source[i];
			}
		}
		/**
		* Save the Matrix as a binary file.
		*/
		void save(const std::string &path)
		{
			std::ofstream os(path.c_str(), std::ios::binary);
			save(os);
			unsigned header[3];
			header[0] = sizeof(T);
			header[1] = N;
			header[2] = dim;
			os.write((char *)header, sizeof header);
			size_t sz = sizeof(T) * dim * N;
			os.write((char *)dims, sz);
		}

		Matrix(const std::string &path) : dims(NULL)
		{
			load(path);
		}
		/**
		* An accessor class to be used with LSH index.
		*/
		class Accessor
		{
			const Matrix &matrix_;
			std::vector<bool> flags_;
		public:
			typedef unsigned Key;
			typedef const T *Value;
			typedef T DATATYPE;
			Accessor(const Matrix &matrix) : matrix_(matrix)
			{
				flags_.resize(matrix_.getSize());
			}
			void reset()
			{
				flags_.clear();
				flags_.resize(matrix_.getSize());
			}
			bool mark(unsigned key)
			{
				if (flags_[key])
				{
					return false;
				}
				flags_[key] = true;
				return true;
			}
			const T *operator () (unsigned key)
			{
				return matrix_[key];
			}
		};
	};
}