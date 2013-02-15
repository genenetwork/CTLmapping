#ifdef __cplusplus
  extern "C" {
#endif
  #ifndef __CORRELATION_H__
    #define __CORRELATION_H__

    #include <math.h>
    #include "ctl.h"
    #include "structs.h"
    
    double correlation(double* x, double* y, size_t dim);

    /* test if a double in NaN */
    static inline int isNaN(double d){ return(d != d); }

    /* Calculate the standard error */
    static inline double stderror(size_t df1, size_t df2){ return(sqrt((1.0 / ((double)(df1-3)) + (1.0 / (double)(df2-3))))); }

    /* Transform a correlation coeficient into a Zscore */
    static inline double zscore(double cor){ return(.5*log((1.0 + cor)/(1.0 - cor))); }

    double chiSQ(size_t nr, double* r, int* nsamples);
    double tstat(double cor, int dim);
  #endif //__CORRELATION_H__
#ifdef __cplusplus
  }
#endif
