#!/usr/bin/env ruby

require 'open-uri'

clowess = open('https://svn.r-project.org/R/tags/R-3-2-4/src/library/stats/src/lowess.c') { |f| f.read }

rmath_stub = <<EOT
double fmax2(double x, double y) { return (x < y) ? y : x; }
int imin2(int x, int y) { return (x < y) ? x : y; }
int imax2(int x, int y) { return (x < y) ? y : x; }
EOT

boolean_stub = <<EOT
typedef enum { FALSE = 0, TRUE /*, MAYBE */ } Rboolean;
EOT

# From https://svn.r-project.org/R/tags/R-3-2-4/src/main/sort.c
rpsort_stub = <<EOT
static void rPsort2(double *x, int lo, int hi, int k)
{
  double v, w;
  int L, R, i, j;

  for (L = lo, R = hi; L < R; ) {
    v = x[k];
    for(i = L, j = R; i <= j;) {
      while (x[i] < v) i++;
      while (v < x[j]) j--;
      if (i <= j) { w = x[i]; x[i++] = x[j]; x[j--] = w; }
    }
    if (j < k) L = i;
    if (k < i) R = j;
  }
}

static void rPsort(double *x, int n, int k)
{
  rPsort2(x, 0, n-1, k);
}
EOT

out = clowess
  .sub(/#include <Rmath\.h>/, rmath_stub)
  .sub(/#include <R_ext\/Applic\.h>/, '#define R_INLINE inline')
  .sub(/#include <R_ext\/Boolean\.h>/, boolean_stub)
  .sub(/#include <R_ext\/Utils\.h>/, rpsort_stub)
  .sub(/static\r?\nvoid clowess/, 'void clowess')
  .sub(/#include <Rinternals.*/m, '') # drop the R wrapper

open('clowess.c', 'w') { |f| f.write(out) }
