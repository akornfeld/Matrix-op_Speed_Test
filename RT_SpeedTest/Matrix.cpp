#include "stdafx.h"
#include "Matrix.h"
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#include <memory.h>

void fillVector(double *vec, int len, double value) {
	memset(vec, value, len); // is faster for the small Matrix, otherwise not much different from the for loop
	//for (int c=0; c < len; c++) {
	//	vec[c] = value;
	//}
}

Matrix::Matrix(int nr, int nc, double defaultValue)
{
	nrows = nr;
	ncols = nc;

    data = new double*[nrows];
	for  (int r=0; r < nrows; r++) {
		data[r] = new double[ncols];
		fillVector(data[r], ncols, defaultValue);
		//memset(data[r], defaultValue, ncols); // no advantage of putting it inline in any of the functions

	}

}
 
double* Matrix::colMeans() {
	double* result = new double[ ncols ];
	return colMeans(result);
}

double* Matrix::colMeans(double* result) {
	fillVector(result, ncols, 0);
	//memset(result, 0, ncols);

	for (int r=0; r < nrows; r++) { //double[] row : this ) {
		/* "Normal coding */
		for (int c=0; c < ncols; c++) {
			result[c] += data[r][c];
		}
		/* "Hand-optimized" (is slightly faster if not deleting/reallocating on every loop)
		double *rowdata = data[r];
		for (int c=0; c < ncols; c++) {
			result[c] += *rowdata; //[c];
			rowdata++;
		}
		/**/

    }

	for (int c=0; c < ncols; c++) {
		result[c] /= nrows;
	}
    return result;
}
    
double* Matrix::rowMeans() {
	double* result = new double[ nrows ];
	return rowMeans(result);
}

double* Matrix::rowMeans(double* result) {
	fillVector(result, nrows, 0);
	//memset(result, 0, nrows);

	for (int c=0; c < ncols; c++) {
		for (int r=0; r < nrows; r++) { 
			result[r] += data[r][c];
		}
    }

	for (int r=0; r < nrows; r++) {
		result[r] /= ncols;
	}
    return result;
}
    
void Matrix::fillRand() {
    //std::uniform_real_distribution<> distr(0,1);
    errno_t         err;
    unsigned int    number;
	double  value;

	for (int r=0; r < nrows; r++) { 
		for (int c=0; c < ncols; c++) {
			err = rand_s( &number );
			if (err != 0)
			{
				printf_s("The rand_s function failed!\n");
			}
			value = (double)number / ((double) UINT_MAX + 1 ); // 0 .. 1

			data[r][c] = value; //distr(gen);
		}
    }


}
