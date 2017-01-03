#!/bin/bash
cd $1
set -vx
 
if [ ! -f 'debian-binary' -o ! -d 'control' -o ! -d 'data' ] ; then
  echo "No extracted deb file here"
  exit 1
fi
 
if [ -z "$1" -o ! -f "$1" ] ; then
  PKG="../"$(basename $PWD)".deb"
else
  PKG="$1"
fi
echo "Writing new package to $PKG..."
 
rm -f control.tar.gz data.tar.gz "$PKG"
 
cd data && tar -zcf ../data.tar.gz ./ && cd ..
cd control && tar -zcf ../control.tar.gz ./ && cd ..
ar rc "$PKG" debian-binary control.tar.gz data.tar.gz
