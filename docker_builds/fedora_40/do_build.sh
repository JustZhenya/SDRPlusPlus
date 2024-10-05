#!/bin/bash
set -e
cd /root

# Install dependencies and tools
# TODO missing: libairspyhf-dev libairspy-dev libad9361-dev libbladerf-dev liblimesuite-dev
dnf install -y cmake gcc g++ git p7zip p7zip-plugins wget xxd libtool autoconf rpmdevtools \
    fftw-devel glfw-devel volk-devel libzstd-devel libiio-devel libcorrect-devel \
    rtaudio-devel hackrf-devel rtl-sdr-devel portaudio-devel codec2-devel spdlog-devel

# Install SDRPlay libraries
wget https://www.sdrplay.com/software/SDRplay_RSP_API-Linux-3.15.1.run
7z x ./SDRplay_RSP_API-Linux-3.15.1.run
7z x ./SDRplay_RSP_API-Linux-3.15.1
cp x86_64/libsdrplay_api.so.3.15 /usr/lib/libsdrplay_api.so
cp inc/* /usr/include/

# Install libperseus
git clone https://github.com/Microtelecom/libperseus-sdr
cd libperseus-sdr
autoreconf -i
./configure --prefix=/usr
make
make install
ldconfig
cd ..

# Install librfnm
git clone https://github.com/AlexandreRouma/librfnm
cd librfnm
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
make -j2
make install
cd ../../

# Install libfobos
git clone https://github.com/AlexandreRouma/libfobos
cd libfobos
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
make -j2
make install
cd ../../

#-DUSE_INTERNAL_LIBCORRECT=OFF
cd SDRPlusPlus
mkdir build
cd build
cmake .. -DOPT_BUILD_AIRSPY_SOURCE=OFF -DOPT_BUILD_AIRSPYHF_SOURCE=OFF -DOPT_BUILD_BLADERF_SOURCE=OFF -DOPT_BUILD_PLUTOSDR_SOURCE=OFF -DOPT_BUILD_LIMESDR_SOURCE=OFF -DOPT_BUILD_SDRPLAY_SOURCE=ON -DOPT_BUILD_NEW_PORTAUDIO_SINK=ON -DOPT_BUILD_M17_DECODER=ON -DOPT_BUILD_PERSEUS_SOURCE=ON -DOPT_BUILD_RFNM_SOURCE=ON -DOPT_BUILD_FOBOSSDR_SOURCE=ON
make VERBOSE=1 -j`nproc`

cd ..
sh make_rpm_package.sh ./build