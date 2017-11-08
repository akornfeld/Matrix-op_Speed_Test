#pragma once
//#include <random> 
// Remembering to define _CRT_RAND_S prior
// to inclusion statement.
#define _CRT_RAND_S

class Matrix
{
private:
    double **data;
    int nrows;
    int ncols;
	// uncomment to use a non-deterministic seed
    //    std::random_device rd;
    //    std::mt19937 gen(rd());
    //std::mt19937 gen(1729);
 
    //Matrix() { } // private default constructor
 
public:
    Matrix(int nrows, int ncols, double defaultValue);
	~Matrix(void) { 
		// NOTE: This is dangerous since we don't make deep copies of the data:
		for(int i = 0; i < nrows; ++i) {
			delete [] data[i];
		}
		delete[] data; 
	}

	// compute column means; the first version creates the result vector; the second doesn't
	double* colMeans();
	double* colMeans(double* result);

	double* rowMeans();
	double* rowMeans(double* result);

	// fill a  matrix with random numbers between 0 and 1
	void fillRand();

	int getNcols() {return ncols;}
	int getNrows() {return nrows;}
};

