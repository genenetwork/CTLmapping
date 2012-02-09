/**********************************************************************
 * src/ctl/io/qtab/wrapper.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 **********************************************************************/
module ctl.io.qtab.wrapper;

import std.stdio;

import ctl.core.array.matrix;
import ctl.io.reader;

import qtl.plugins.qtab.read_qtab;
import qtl.core.phenotype;
import qtl.core.genotype;
import qtl.core.primitives;

class QTABreader : Reader{
  double[][] loadphenotypes(string filename = "phenotype.qtab"){
    auto res = read_phenotype_qtab!(Phenotype!double)(filename);
    Phenotype!double[][] pheno = res[0];
    double[][] phenotypes = newmatrix!double(pheno.length,pheno[0].length);
    for(size_t x=0;x< pheno.length;x++){
      for(size_t y=0;y< pheno[0].length;y++){
        phenotypes[x][y] = pheno[x][y].value;
      }
    }
    return phenotypes;
  }
    
  int[][] loadgenotypes(string filename = "genotype"){
    string symbol_fn   = filename ~ "_symbol.qtab";
    string genotype_fn = filename ~ ".qtab";
    
    auto symbols = read_genotype_symbol_qtab(File(symbol_fn,"r"));
    auto ret = read_genotype_qtab(File(genotype_fn,"r"), symbols);
    auto individuals = ret[0];
    auto genotype_matrix = ret[1];
    
    int[][] genotypes = newmatrix!int(genotype_matrix.length,genotype_matrix[0].length);
    
    for(size_t x=0;x< genotype_matrix.length;x++){
      for(size_t y=0;y< genotype_matrix[0].length;y++){
      if(genotype_matrix[x][y] == symbols.decode("A")){
        genotypes[x][y] = 0;
      }
      if(genotype_matrix[x][y] == symbols.decode("B")){
        genotypes[x][y] = 1;
      }
      }
    }
    return genotypes;
  }
}
