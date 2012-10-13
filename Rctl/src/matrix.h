#ifdef __cplusplus
  extern "C" {
#endif
  #ifndef __MATRIX_H__
    #define __MATRIX_H__

    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>
    #include <float.h>
    #include "ctl.h"
    #include "vector.h"

    double** newdmatrix(size_t rows, size_t cols);
    int**    newimatrix(size_t rows, size_t cols);
    
    double** addtodmatrix(double** matrix, size_t size, size_t cols, double* n);
    int**    addtoimatrix(int** matrix, size_t size, size_t cols, int* n);
    
    double** asdmatrix(int rows, int cols, double* data);
    int**    asimatrix(int rows, int cols, int* data);

    double matrixmax(double** m, size_t rows, size_t cols);
    
    void printdmatrix(double** m, size_t rows, size_t cols);
    void printimatrix(int** m, size_t rows, size_t cols);
    void freematrix(void** m, size_t rows);

  #endif //__MATRIX_H__
#ifdef __cplusplus
  }
#endif