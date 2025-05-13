#!/bin/sh

# Create directory structure
echo Create directory structure
DIR=sdrpp_debian_$2
mkdir $DIR
mkdir $DIR/DEBIAN

# Create package info
echo Create package info
echo Package: sdrpp >> $DIR/DEBIAN/control
echo Version: 1.2.1$BUILD_NO >> $DIR/DEBIAN/control
echo Maintainer: Ryzerth, just_zhenya >> $DIR/DEBIAN/control
echo Architecture: $2 >> $DIR/DEBIAN/control
echo Description: Bloat-free SDR receiver software >> $DIR/DEBIAN/control
echo Depends: $3 >> $DIR/DEBIAN/control
echo Recommends: $4 >> $DIR/DEBIAN/control

# Copying files
echo Copy files
ORIG_DIR=$PWD
cd $1
make install DESTDIR=$ORIG_DIR/$DIR
cd $ORIG_DIR

# Create package
echo Create package
dpkg-deb --build $DIR

# Cleanup
echo Cleanup
rm -rf $DIR
