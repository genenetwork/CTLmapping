/******************************************************************//**
 * \file ctl/core/ctl/utils.d
 * \brief Utility classes for CTL mapping
 *
 * <i>Copyright (c) 2012</i>GBIC - Danny Arends<br>
 * Last modified May, 2012<br>
 * First written Jan, 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module ctl.core.ctl.utils;

import std.stdio, std.conv, std.string, std.c.stdlib;
import ctl.core.array.matrix;

/* Write an error string to stderr */
void error(in string s){
  stderr.writeln();
  stderr.writefln("-Error: %s\n", s);
}

/* Abort with error code, default: -1 */
void abort(in string s, int exitcode = -1){
  error(s);
  exit(exitcode);
}

pure size_t[] which(T)(in T[] marker,in T type = 0){
  size_t[] indices;
  for(size_t i=0; i < marker.length; i++){ if(marker[i] == type) indices ~= i; }
  return indices;
}

pure T[] get(T)(in T[] phenotype, size_t[] r){
  T[] ph;
  ph.length = r.length;
  for(size_t x=0;x<r.length;x++){ ph[x] = phenotype[r[x]]; }
  return ph;
}

unittest{
  writefln("Unit test: %s", __FILE__);
  string test_fun;
  try{
    test_fun = "pure size_t[] which(in int[] marker, int type = 0)";
    assert(which([3,4],4) == [1],                     "\n"~test_fun~" Test 1");
    assert(which([3,4,6,7,8,3,4],4) == [1,6],         "\n"~test_fun~" Test 2");
    writefln("Tests: %s",test_fun);

    test_fun = "pure double[] get(in double[] phenotype, size_t[] r)";
    assert(get([2.0, 4.0, 5.0],[1,2]) == [4.0,5.0],   "\n"~test_fun~" Test 1");
    assert(get([2.0, 4.0, 5.0],[0,2]) == [2.0,5.0],   "\n"~test_fun~" Test 2");
    writefln("Tests: %s",test_fun);

    writefln("Tested: %s",__FILE__);  
  }catch(Throwable e){
    string err = to!string(e).split("\n")[1];
    writefln("Reason: %s failed", err);
  }
}
