#!/bin/bash
 
if [ ! -f "$1" ] ; then
  echo "No such file"
fi
 
DIR=${1%%.deb}
mkdir "$DIR" && cd "$DIR"
ar x "../$1"
mkdir data control
cd data && tar -zxf ../data.tar.gz && cd ..
cd control && tar -zxf ../control.tar.gz
