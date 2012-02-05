/**********************************************************************
 * src/qcl/io/csv/parse.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Jan, 2012
 * first written Jan, 2012
 **********************************************************************/
module qcl.io.csv.parse;

import std.stdio;
import std.string;
import std.file;
import std.conv;

import qcl.core.array.matrix;

struct D{
  string  name;
  char    chr = '0';
  double  loc = 0.0;
  
  this(string[] d){
    name = d[0];
    try{
    if(d[1] != "") chr  = to!char(d[1]);
    if(d[2] != "") loc  = to!double(d[2]);
    }catch(Throwable t){ }
  }
}

T[][] parseFile(T)(string filename, bool verbose = false){
  T[][] data;
  D[]   descr;
  if(!exists(filename) || !isFile(filename)){
    writefln("No such file %s",filename);
  }else{
    try{
      auto fp = new File(filename,"rb");
      string      buffer;
      while(fp.readln(buffer)){
        buffer = chomp(buffer);
        string[] splitted = buffer.split("\t");
        if(splitted.length > 3){
          descr ~= D(splitted[0..2]);
          data ~= stringvectortotype!T(splitted[3..$]);
        }
      }
      fp.close();
      if(verbose) writefln("Parsed %s imports from file: %s",data.length, filename);
    }catch(Throwable e){
      writefln("File %s read exception: %s", filename,e);
    }
  }
  return data;
}
