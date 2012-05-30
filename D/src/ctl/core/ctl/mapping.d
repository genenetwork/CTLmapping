/******************************************************************//**
 * \file ctl/core/ctl/mapping.d
 * \brief Map CTL for a single phenotypes
 *
 * <i>Copyright (c) 2012</i>GBIC - Danny Arends<br>
 * Last modified May, 2012<br>
 * First written Jan, 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module ctl.core.ctl.mapping;

import std.stdio, std.math, std.datetime;
import ctl.core.array.matrix, ctl.io.terminal;
import ctl.core.ctl.utils;
import ctl.core.stats.correlation;

double[][] mapping(double[][] phenotypes, int[][] genotypes, uint phenotype = 1, bool verbose = true){
  assert(phenotype < phenotypes.length);
  SysTime stime = Clock.currTime();
  double[][] difcormatrix = newmatrix!double(genotypes.length,phenotypes.length);
  for(uint m=0; m<genotypes.length; m++){
    uint[] ind_aa  = which(genotypes[m],0);
    uint[] ind_bb  = which(genotypes[m],1);
    double[] pheno_aa = get(phenotypes[phenotype],ind_aa);
    double[] pheno_bb = get(phenotypes[phenotype],ind_bb);
    for(uint p=0; p<phenotypes.length; p++){
      double cor_aa = correlation!double(pheno_aa, get(phenotypes[p],ind_aa));
      double cor_bb = correlation!double(pheno_bb, get(phenotypes[p],ind_bb));
      difcormatrix[m][p] = ((mysign(cor_aa)*pow(cor_aa,2)) - (mysign(cor_bb)*pow(cor_bb,2)));
    }
  }
  if(verbose) MSG("CTL mapping took: (%s msecs)",(Clock.currTime()-stime).total!"msecs"());
  return difcormatrix;
}
