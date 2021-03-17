FROM ubuntu:20.04

ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get update \
    && apt-get -y install \
    build-essential autoconf pkg-config libtool tzdata cmake wget curl git \
    libpcap-dev libhwloc-dev libluajit-5.1-dev libssl-dev libpcre3-dev zlib1g-dev liblzma-dev \
    && rm -rf /var/lib/apt/lists/*

# fix timezone
RUN echo "US/Mountain" > /etc/timezone  \
    && ln -fs /usr/share/zoneinfo/`cat /etc/timezone` /etc/localtime \
    && dpkg-reconfigure tzdata

WORKDIR /snort3

RUN wget -c https://github.com/snort3/libdaq/archive/v3.0.1.tar.gz -O - | tar -xz \
    && cd libdaq-3.0.1 && ./bootstrap && ./configure && make -j7 && make install \
    && cd .. && rm -rf libdaq-3.0.1

RUN wget -c https://github.com/ofalk/libdnet/archive/libdnet-1.14.tar.gz -O - | tar -xz \
    && cd libdnet-libdnet-1.14 && ./configure && make -j7 && make install \
    && cd .. && rm -rf libdnet-libdnet-1.14

RUN wget -c https://github.com/snort3/snort3/archive/3.1.2.0.tar.gz -O - | tar -xz \
    && cd snort3-3.1.2.0 && ./configure_cmake.sh --prefix=/usr/local && cd build && make -j7 && make install \
    && cd ../.. && rm -rf snort3-3.1.2.0
