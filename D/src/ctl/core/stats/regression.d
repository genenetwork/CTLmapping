/**********************************************************************
 * src/ctl/core/stats/regression.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Jan, 2012
 * first written Jan, 2012
 **********************************************************************/
module ctl.core.stats.regression;

import std.stdio;
import std.math;
import ctl.core.array.matrix;
import ctl.core.array.ranges;
import ctl.core.stats.utils;

double multipleregression(double[][] designmatrix, double[] y, double[] weight, int[] nullmodellayout, bool verbose = true){
  if (designmatrix.length != weight.length){ writeln("No weights for individuals found",designmatrix.length,weight.length); return 0.0; }
  if (designmatrix.length != y.length) { writefln("No y variable for some individuals found"); return 0.0; }
  
  double sum=0;
  foreach(int i,double d; designmatrix[0]){ sum+=d; }
  if(!sum == y.length){
    writefln("NOTE: No estimate of constant in model");
  }
  double model_likelihood = 2*likelihoodbyem(designmatrix, weight, y, verbose).logL;
  double null_likelihood = 2*nullmodel(designmatrix, weight, y, nullmodellayout, verbose).logL;
  return ((model_likelihood - null_likelihood) / 4.60517);
}

FITTED likelihoodbyem(double[][] x, double[] w, double[] y, bool verbose){
  uint   nvariables = cast(uint)x[0].length;
  uint   nsamples   = cast(uint)x.length;
  uint   maxemcycles = 1000;
  uint   emcycle     = 0;
  double delta       = 1.0f;
  double logL        = 0.0f;
  double logLprev    = 0.0f;
  
  FITTED f;
  if(verbose) writefln("Starting EM:");
  while((emcycle<maxemcycles) && (delta > 1.0e-9)){
    f = multivariateregression(x, w, y);

    for(uint s=0;s<nsamples;s++){
      if(w[s] != 0) w[s] = (w[s] + f.Fy[s])/w[s];
    }
    delta = fabs(f.logL-logLprev);
    logLprev=f.logL;
    emcycle++;
  }
  
  if(verbose) writefln("EM took %d/%d cyclies", emcycle, maxemcycles);
  f = multivariateregression(x,w,y);
  return f;
}

FITTED nullmodel(double[][] x, double[] w, double[] y,int[] nullmodellayout,bool verbose){
  return multivariateregression(x, w, y, nullmodellayout, verbose);
}

FITTED multivariateregression(double[][] x, double[] w, double[] y, int[] nullmodellayout = [], bool verbose = false){
  uint nvariables = cast(uint)x[0].length;
  uint nsamples   = cast(uint)x.length;
  double[][] Xt = translate!double(x);
  double[] XtWY  = calculateparameters(nvariables,nsamples,Xt,w,y,verbose);
  if(nullmodellayout.length != 0){
    for(uint i=1; i < nvariables; i++){
      if(nullmodellayout[(i-1)] == 1){ //SHIFTED Because the nullmodel has always 1 parameter less (The first parameter estimated mean)
        XtWY[i] = 0.0;
      }
    }
  }
  STATS s = calculatestatistics(nvariables, nsamples, Xt, XtWY, y, w,verbose);
  FITTED f = calculateloglikelihood(nsamples, s.residual, w, s.variance, verbose);
  
  if(verbose){
    writefln("Variance: %s",s.variance);
    writefln("Weights: %s",w);
    writefln("Estimated parameters: %s %s",XtWY);
    writefln("Estimated fit: %s", s.fit);
    writefln("Estimated residuals: %s" ,s.residual);
    writefln("Loglikelihood: %s",f.logL);
  }

  return f;
}