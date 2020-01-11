ARG UBUNTU_VERSION=16.04

FROM tensorflow/tensorflow:1.12.0-py3

ARG RUNTIME_DEPS='wget unzip git'
ARG BUILD_DEPS='wget unzip git cmake yasm coreutils autoconf automake libtool diffutils texinfo jq pkg-config build-essential \
                libssl-dev libpng-dev libjpeg-turbo8-dev libtiff-dev libopenexr-dev libjasper-dev libopenblas-dev zlib1g.dev'
ARG NASM_VERSION=2.14.02
ARG OPENCV_VERSION=4.0.1
ARG DLIB_VERSION=19.16
ARG FFMPEG_VERSION=4.1
ARG MP3LAME_VERSION=3.100
ARG FDK_AAC_VERSION=0.1.6
ARG OGG_VERSION=1.3.3
ARG VORBIS_VERSION=1.3.6
ARG OPUS_VERSION=1.3
ARG THEORA_VERSION=1.1.1
ARG VPX_VERSION=1.7.0
# x264 only have a stable branch no tags
ARG X264_VERSION=0a84d986e7020f8344f00752e3600b9769cc1e85
ARG X265_VERSION=2.9
ARG WEBP_VERSION=1.0.0
ARG WAVPACK_VERSION=5.1.0
ARG SPEEX_VERSION=1.2.0
ARG AOM_VERSION=1.0.0
ARG VIDSTAB_VERSION=1.1.0
ARG KVAZAAR_VERSION=1.2.0


# -O3 makes sure we compile with optimization. setting CFLAGS/CXXFLAGS seems to override
# default automake cflags.
# -static-libgcc is needed to make gcc not include gcc_s as "as-needed" shared library which
# cmake will include as a implicit library.
# other options to get hardened build (same as ffmpeg hardened)
ARG CFLAGS="-O3 -shared-libgcc -fno-strict-overflow -fstack-protector-all"
ARG CXXFLAGS="-O3 -shared-libgcc -fno-strict-overflow -fstack-protector-all"
# ARG LDFLAGS="-Wl,-z,relro -fPIE -pie"


ENV FFMPEG_PATH='/usr/bin/ffmpeg'
ENV FFPROBE_PATH='/usr/bin/ffprobe'


RUN mv /etc/apt/sources.list /etc/apt/sources.list.old \
    && echo "deb http://mirrors.163.com/ubuntu/ xenial main restricted universe multiverse"               >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.163.com/ubuntu/ xenial main restricted universe multiverse"           >> /etc/apt/sources.list \
    && echo "deb http://mirrors.163.com/ubuntu/ xenial-security main restricted universe multiverse"      >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.163.com/ubuntu/ xenial-security main restricted universe multiverse"  >> /etc/apt/sources.list \
    && echo "deb http://mirrors.163.com/ubuntu/ xenial-updates main restricted universe multiverse"       >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.163.com/ubuntu/ xenial-updates main restricted universe multiverse"   >> /etc/apt/sources.list \
    && echo "deb http://mirrors.163.com/ubuntu/ xenial-proposed main restricted universe multiverse"      >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.163.com/ubuntu/ xenial-proposed main restricted universe multiverse"  >> /etc/apt/sources.list \
    && echo "deb http://mirrors.163.com/ubuntu/ xenial-backports main restricted universe multiverse"     >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.163.com/ubuntu/ xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list

ADD install.sh requirements.txt /

RUN sh /install.sh

VOLUME ["/shared"]

CMD ["/bin/bash"]
