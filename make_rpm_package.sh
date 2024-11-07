#!/bin/sh

# Create directory structure
echo Create directory structure
rpmdev-setuptree

# Create package info
cat <<EOF >> ~/rpmbuild/SPECS/sdrpp.spec
%global __requires_exclude libhackrf.so.0|libportaudio.so.2|librtlsdr.so.0|libfobos.so|libperseus-sdr.so.0|librfnm.so|libsdrplay_api.so.3
%define _unpackaged_files_terminate_build 0

Name:       sdrpp
Version:    1.2.0
Release:    $BUILD_NO
Summary:    SDR++
Recommends: libhackrf.so.0()(64bit), libportaudio.so.2()(64bit), librtlsdr.so.0()(64bit), libfobos.so()(64bit), libperseus-sdr.so.0()(64bit), librfnm.so()(64bit), libsdrplay_api.so.3()(64bit)
License:    GPLv3+

%description
SDR++ is a cross-platform and open source SDR software with the aim of being bloat free and simple to use.

%install
cd /root/SDRPlusPlus/build
%make_install

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

# Create package
echo Create package
rpmbuild -ba ~/rpmbuild/SPECS/sdrpp.spec
