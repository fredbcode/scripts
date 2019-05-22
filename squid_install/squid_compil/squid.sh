#!/bin/bash
set -vx
SQUID_PKG="4.6-2"
SQUID_VER="4.6"
REAL_VER="4.7"

      # drop squid build folder
      rm -R build/squid

      # we will be working in a subfolder make it
      mkdir -p build/squid

      # set squid version
      source squid.ver

      cd build/squid

      # get squid from debian experimental
      wget http://http.debian.net/debian/pool/main/s/squid/squid_${SQUID_PKG}.dsc
      wget http://http.debian.net/debian/pool/main/s/squid/squid_${SQUID_VER}.orig.tar.gz
      wget http://www.squid-cache.org/Versions/v4/squid-${REAL_VER}.tar.gz
      wget http://http.debian.net/debian/pool/main/s/squid/squid_${SQUID_PKG}.debian.tar.xz

      # unpack the source package
      dpkg-source -x squid_${SQUID_PKG}.dsc
      tar -xvf squid-${REAL_VER}.tar.gz

      # modify configure options in debian/rules, add --enable-ssl --enable-ssl-crtd
      # And upgrade to the latest source from squid

      cp  ../../rules squid-${SQUID_VER}/debian/
      cp -r squid-${REAL_VER}/* squid-${SQUID_VER}/
      cp ../../squid-common.install squid-${SQUID_VER}/debian 
      sed -i "s/Version:.*$/Version:\ $REAL_VER/g" squid_${SQUID_PKG}.dsc 
      cd squid-${SQUID_VER} && autoreconf -f -i && dpkg-buildpackage -rfakeroot -b
      cd ..
      for deb in *.deb; do mv "$deb" `echo $deb | tr ${SQUID_VER} ${REAL_VER} `; done
