#!/bin/sh

# Create directory structure
echo Create directory structure
mkdir ~/rpmbuild
mkdir ~/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
mkdir ~/rpmbuild/BUILDROOT/sdrpp-1.2.0$BUILD_NO-1.x86_64/

# Create package info
cat <<EOF >> ~/rpmbuild/SPECS/sdrpp.spec
%global __requires_exclude libhackrf.so.0|libportaudio.so.2|librtlsdr.so.0|libfobos.so|libperseus-sdr.so.0|librfnm.so|libsdrplay_api.so.3

Name:       sdrpp
Version:    1.2.0$BUILD_NO
Release:    1
Summary:    SDR++
Recommends: libhackrf.so.0()(64bit), libportaudio.so.2()(64bit), librtlsdr.so.0()(64bit), libfobos.so()(64bit), libperseus-sdr.so.0()(64bit), librfnm.so()(64bit), libsdrplay_api.so.3()(64bit)
License:    GPLv3+

%description
SDR++ is a cross-platform and open source SDR software with the aim of being bloat free and simple to use.

%post
/sbin/ldconfig

%postun
/sbin/ldconfig

%files
/usr/lib/libsdrpp_core.so
/usr/lib/sdrpp
/usr/bin/sdrpp
/usr/share/applications/sdrpp.desktop
/usr/share/sdrpp
EOF

# Copying files
echo Copy files
cd $1
make install DESTDIR=~/rpmbuild/BUILDROOT/sdrpp-1.2.0$BUILD_NO-1.x86_64/

# Create package
echo Create package
cd ~/rpmbuild/SPECS
rpmbuild -ba sdrpp.spec
