/******************************************************************//**
 * \file Rctl/src/correlation.h
 * \brief Definition of functions related to correlation
 *
 * <i>Copyright (c) 2010-2013</i> GBIC - Danny Arends<br>
 * Last modified Feb, 2013<br>
 * First written 2011<br>
 **********************************************************************/
#ifdef __cplusplus
  extern "C" {
#endif
  #ifndef __CORRELATION_H__
    #define __CORRELATION_H__

    #include "ctl.h"
    #include "structs.h"

    /** Calculates pearsons correlation between vector x and vector y.  Use ranked 
     *  input for non-parametric testing */
    double  correlation(const double* x, const double* y, size_t dim, bool verbose);

    /** Calculates pearsons correlation between vector x and matrix y. Use ranked 
     *  input for non-parametric testing<br>
     *  <b>TODO</b>: Use the Kahan Accumulator */
    double* cor1toN(const double* x, double** y, size_t dim, size_t ny, bool verbose);


    /** Calculate the correlations for all genotype encodings between P1 and P2 at marker M. */
    double* getCorrelations(const Phenotypes phenotypes, const Genotypes genotypes, size_t phe1, 
                            clvector genoenc, size_t mar, size_t phe2, bool verbose);

    /** Test if a double in NaN. */
    static inline int isNaN(double d){ return(d != d); }

    /** Calculate the standard error. */
    static inline double stderror(size_t df1, size_t df2){ 
      return(sqrt((1.0 / ((double)(df1-3)) + (1.0 / (double)(df2-3))))); 
    }

    /** Transform a correlation coeficient into a Zscore. */
    static inline double zscore(double cor){ return(.5*log((1.0 + cor)/(1.0 - cor))); }

    /** Calculate the chi square test statistic based on N segregating correlations. */
    double* chiSQN(size_t nr, double** r, size_t phe, int* nsamples, size_t nphe);
    /** Calculate the chi square test statistic based on N seggregating correlations. */
    double  chiSQ(size_t nr, double* r, int* nsamples);
    /** Transforms a chi square critical value (Cv) to a p-value. */
    double  chiSQtoP(int Dof, double Cv);

  #endif //__CORRELATION_H__
#ifdef __cplusplus
  }
#endif
