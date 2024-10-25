#!/bin/bash
set -e
cd /root

# Install dependencies and tools
apt update
apt install -y build-essential cmake git libfftw3-dev libglfw3-dev libvolk2-dev libzstd-dev libairspyhf-dev libairspy-dev \
            libiio-dev libad9361-dev librtaudio-dev libhackrf-dev librtlsdr-dev libbladerf-dev liblimesuite-dev p7zip-full wget portaudio19-dev \
            libcodec2-dev autoconf libtool xxd libspdlog-dev

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
./configure
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

cd SDRPlusPlus
mkdir build
cd build
cmake .. -DOPT_BUILD_BLADERF_SOURCE=ON -DOPT_BUILD_LIMESDR_SOURCE=ON -DOPT_BUILD_SDRPLAY_SOURCE=ON -DOPT_BUILD_NEW_PORTAUDIO_SINK=ON -DOPT_BUILD_M17_DECODER=ON -DOPT_BUILD_PERSEUS_SOURCE=ON -DOPT_BUILD_RFNM_SOURCE=ON -DOPT_BUILD_FOBOSSDR_SOURCE=ON
make VERBOSE=1 -j2

cd ..
sh make_debian_package.sh ./build 'amd64' 'libc6, libgcc-s1, libstdc++6, libvolk2.4, libfftw3-single3, librtaudio6, libzstd1, libglfw3, libopengl0' 'libportaudio2, libad9361-0, libairspyhf1, libairspy0, libbladerf2, libcodec2-0.9, libhackrf0, libiio0, liblimesuite20.10-1, librtlsdr0'