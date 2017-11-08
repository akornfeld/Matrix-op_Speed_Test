// RT_SpeedTest.cpp : 
//   Test computational efficiency for computing the column means of a matrix
//    -- part of a cross-language comparison with MATLAB, Java, ...

#include "stdafx.h"
#include "Matrix.h"
#include <stdlib.h>
#include <stdio.h>
#include <time.h>       /* time_t, struct tm, difftime, time, mktime */
#include <iostream>     // std::cin, std::cout
// #include <fstream>      // std::ifstream

/*
 "Release" Build (x64): [repeated twice to confirm longer interval for last one; all were the same]
  Elapsed time:  3.14 s :  Small array, many iterations.
  Elapsed time:  4.08 s :  Small array, many iterations, no re-allocation.
  Elapsed time:  2.44 s :  10x cols, 10x fewer iterations.
  Elapsed time:  3.66 s :  10x cols, 10x fewer iterations, no re-allocation.
  Elapsed time:  1.82 s :  10x rows, 10x fewer iterations.
  Elapsed time:  2.10 s :  10x rows, 10x fewer iterations, row means.
  Elapsed time:  3.10 s :  10x rows, 10x fewer iterations, row means, no re-allocation.
  Elapsed time:  2.53 s :  100x cols, 100x fewer iterations.
  Elapsed time:  2.65 s :  500x cols, 500x fewer iterations.

 "Release" Build (w32):
  Elapsed time (seconds):  4.21, :  Small array, many iterations.
  Elapsed time (seconds):  3.78, :  Small array, many iterations, no re-allocation.
  Elapsed time (seconds):  3.85, :  10x cols, 10x fewer iterations.
  Elapsed time (seconds):  3.80, :  10x cols, 10x fewer iterations, no re-allocation..

 Debug build (w32):
  Elapsed time (seconds): 11.76, :  Small array, many iterations.
  Elapsed time (seconds): 10.16, :  Small array, many iterations, no re-allocation.
  Elapsed time (seconds):  9.94, :  10x cols, 10x fewer iterations.
  Elapsed time (seconds):  9.69, :  10x cols, 10x fewer iterations, no re-allocation..

 With debugger active (w32; but no breakpoints):
  Elapsed time: 28.61 s :  Small array, many iterations.
  Elapsed time:  9.91 s :  Small array, many iterations, no re-allocation.
  Elapsed time: 15.84 s :  10x cols, 10x fewer iterations.
  Elapsed time:  9.65 s :  10x cols, 10x fewer iterations, no re-allocation.
  Elapsed time: 10.05 s :  10x rows, 10x fewer iterations.
  Elapsed time:  9.83 s :  10x rows, 10x fewer iterations, row means.
  Elapsed time:  9.02 s :  10x rows, 10x fewer iterations, row means, no re-allocation.
  Elapsed time: 10.12 s :  100x cols, 100x fewer iterations.
  Elapsed time: 10.11 s :  500x cols, 500x fewer iterations.
*/

void tic();
void toc(char* comment);
void small_array_op(Matrix* my_m, int n_iter);
void small_array_op2(Matrix* my_m, int n_iter);
void cols_array(Matrix* my_m, int n_iter);
void cols_array2(Matrix* my_m, int n_iter);
void rows_array(Matrix* my_m, int n_iter);
void rows_array2(Matrix* my_m, int n_iter);

int _tmain(int argc, _TCHAR* argv[])
{
    int nrows = 13;
    int ncols = 36;
    int n_iter = 626178; // 626178;  // 6,261,780 / 10  (another time SCOPE made 7,560,938 calls)
    Matrix small_m(nrows, ncols, 0);  // or rand(13,36);
    Matrix m_10x_rows(nrows*10, ncols, 0);  // or rand(130,36);
    Matrix m_10x_cols(nrows, ncols*10, 0);  // or rand(13,360);
    Matrix m_100x_cols(nrows, ncols*100, 0);  // or rand(13,360);
    Matrix m_500x_cols(nrows, ncols*500, 0);  // or rand(13,360);

    // fill with random numbers:
    small_m.fillRand();
    m_10x_rows.fillRand();
    m_10x_cols.fillRand();
    m_100x_cols.fillRand();
    m_500x_cols.fillRand();
    
    //  tic toc is for convenience only
    // note the different function names differentiate them for the profiler ("Run and Time")
    // all three functions are identical
    tic();
    small_array_op(&small_m, n_iter*10);  // 10x iterations
    toc(":  Small array, many iterations.");

    tic();
    small_array_op2(&small_m, n_iter*10);  // 10x iterations, no re-allocation.
    toc(":  Small array, many iterations, no re-allocation.");

	tic();
    cols_array(&m_10x_cols, n_iter); // 10x columns
    toc(":  10x cols, 10x fewer iterations.");

	tic();
    cols_array2(&m_10x_cols, n_iter); // 10x columns, no re-allocation.
    toc(":  10x cols, 10x fewer iterations, no re-allocation.");

   tic();
    cols_array(&m_10x_rows, n_iter);  // 10x rows
    toc(":  10x rows, 10x fewer iterations.");

    tic();
    rows_array(&m_10x_rows, n_iter);  // 10x rows, row means
    toc(":  10x rows, 10x fewer iterations, row means.");
	
    tic();
    rows_array2(&m_10x_rows, n_iter);  // 10x rows, row means, no re-allocation.
    toc(":  10x rows, 10x fewer iterations, row means, no re-allocation.");
	
    tic();
    cols_array(&m_100x_cols, n_iter/10); // 100x columns, note that the base # of iterations is already max_iter/10 
    toc(":  100x cols, 100x fewer iterations.");

    tic();
    cols_array(&m_500x_cols, n_iter/50); //500x columns, note that the base # of iterations is already max_iter/10 
    toc(":  500x cols, 500x fewer iterations.");

	std::cout << "Press Enter to Continue";
	std::cin.get();
	return 0;
}


void small_array_op(Matrix* my_m, int n_iter) {
    double* m1 = NULL;
    for (int i =  1; i <= n_iter ; i++ ) {
        m1 = my_m->colMeans();
		if (m1 != NULL) {
			delete[] m1;
		}
    }
    // just a little junk code to use m
    //m1 = m1 + 1;
}

void small_array_op2(Matrix* my_m, int n_iter) {
    double* m1 = new double[ my_m->getNcols() ];
    for (int i =  1; i <= n_iter ; i++ ) {
        m1 = my_m->colMeans(m1);
    }
    // just a little junk code to use m
    //m1 = m1 + 1;
	if (m1 != NULL) {
		delete[] m1;
	}
}

void cols_array(Matrix* my_m, int n_iter) {
    double* m1 = NULL;
    for (int i =  1; i <= n_iter ; i++ ) {
        m1 = my_m->colMeans();
		if (m1 != NULL) {
			delete[] m1;
		}
    }
    // just a little junk code to use m
    //m1 = m1 + 1;
}

void cols_array2(Matrix* my_m, int n_iter) {
    double* m1 = new double[ my_m->getNcols() ];
    for (int i =  1; i <= n_iter ; i++ ) {
        m1 = my_m->colMeans(m1);
    }
    // just a little junk code to use m
    //m1 = m1 + 1;
	if (m1 != NULL) {
		delete[] m1;
	}
}

void rows_array(Matrix* my_m, int n_iter) {
    double* m1 = NULL;
    for (int i =  1; i <= n_iter ; i++ ) {
        m1 = my_m->rowMeans();
		if (m1 != NULL) {
			delete[] m1;
		}
    }
    // just a little junk code to use m
    //m1 = m1 + 1;
}

void rows_array2(Matrix* my_m, int n_iter) {
    double* m1 = new double[ my_m->getNrows() ];
    for (int i =  1; i <= n_iter ; i++ ) {
        m1 = my_m->rowMeans(m1);
    }
    // just a little junk code to use m
    //m1 = m1 + 1;
	if (m1 != NULL) {
		delete[] m1;
	}
}


/*
void cols_jumbo_array(Matrix my_m, int n_iter) {
    double* m1 = NULL;
    for (int i =  1; i <= n_iter ; i++ ) {
        m1 = my_m.colMeans();
    }
    // just a little junk code to use m
    //m1 = m1 + 1;
	if (m1 != NULL) {
		delete[] m1;
	}
}

void rows_array(Matrix my_m, int n_iter) {
    double* m1 = NULL;
    for (int i =  1; i <= n_iter ; i++ ) {
        m1 = my_m.colMeans();
    }
    // just a little junk code to use m
    //m1 = m1 + 1;
	if (m1 != NULL) {
		delete[] m1;
	}
}

void rows_array2(Matrix my_m, int n_iter) {
    double* m1 = NULL;
    for (int i =  1; i <= n_iter ; i++ ) {
        m1 = my_m.colMeans();
    }
    // just a little junk code to use m
    //m1 = m1 + 1;
	if (m1 != NULL) {
		delete[] m1;
	}
}
*/

//static time_t  t1;
static clock_t ct1;

void tic() {
//	time(&t1);  /* get current time; same as: timer = time(NULL)  */
	ct1 =  clock();
}
    
void toc(char* comment) {
    double ct_s; //, elapsedTime_s
//	time_t  t2;
	clock_t ct2;

//	time(&t2);  /* get current time; same as: timer = time(NULL)  */
	ct2 = clock();

    //elapsedTime_s =difftime(t2, t1);
	ct_s = (double) (ct2 - ct1)/CLOCKS_PER_SEC;
	//std::cout << 
    //printf_s("  Elapsed time (seconds): %5.4f, or %5.4f, %s\n", elapsedTime_s, ct_s, comment);
    printf_s("  Elapsed time: %5.2f s %s\n", ct_s, comment);

}
