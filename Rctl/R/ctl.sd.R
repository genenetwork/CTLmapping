#
# ctl.sd.R
#
# copyright (c) 2010-2013 - GBIC, Danny Arends and Ritsert C. Jansen
# last modified Apr, 2013
# first written Apr, 2013
# 
# SD analysis for CTL analysis
#

deltaSD <- function(t1, t2, geno){
  group   <- 1
  sdR <- NULL
  for(g in unique(geno)){
    ind <- which(geno == g)
    sdR <- c(sdR, sd(t1[ind], na.rm=TRUE) / sd(t2[ind], na.rm=TRUE))
  }
  return(sdR)
}

#-- Normal interface --#
scanSD <- function(genotypes, phenotypes, phenocol=c(1, 2), doRank = FALSE){
  if(missing(phenotypes)) stop("argument 'phenotypes' is missing, with no default")
  if(missing(genotypes)) stop("argument 'genotypes' is missing, with no default")
  if(length(phenocol) != 2) stop("argument 'phenocol' needs to select two phenotypes")

  if(doRank) genotypes <- apply(genotypes, 2, rank)

  matrix <- NULL
  for(m in 1:ncol(genotypes)){
    res <- deltaSD(phenotypes[, phenocol[1]], phenotypes[, phenocol[2]], genotypes[, m])
    matrix <- rbind(matrix, res)
  }
  return(matrix)
}

#-- R/qtl interface --#
scanSD.cross <- function(cross, phenocol = c(1, 2), doRank = FALSE){
  if(missing(cross)) stop("argument 'cross' is missing, with no default")
  if(length(phenocol) != 2) stop("argument 'phenocol' needs to select two phenotypes")
  scanSD(pull.geno(cross), pull.pheno(cross), phenocol=phenocol, doRank=doRank)
}

