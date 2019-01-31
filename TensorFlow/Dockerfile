FROM tensorflow/tensorflow:1.12.0-py3

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

ARG RUNTIME_DEPS='wget unzip git'
ARG BUILD_DEPS='cmake gcc yasm coreutils autoconf automake libtool diffutils texinfo jq pkg-config build-essential \
                libssl-dev libpng-dev libjpeg-turbo8-dev libtiff-dev libopenexr-dev libjasper-dev libopenblas-dev zlib1g.dev'
ARG LIB_PREFIX='/usr/local'
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
ARG HTTP_PROXY


# -O3 makes sure we compile with optimization. setting CFLAGS/CXXFLAGS seems to override
# default automake cflags.
# -static-libgcc is needed to make gcc not include gcc_s as "as-needed" shared library which
# cmake will include as a implicit library.
# other options to get hardened build (same as ffmpeg hardened)
# ENV CFLAGS="-O3 -static-libgcc -fno-strict-overflow -fstack-protector-all -fPIE"
# ENV CXXFLAGS="-O3 -static-libgcc -fno-strict-overflow -fstack-protector-all -fPIE"
# ENV LDFLAGS="-Wl,-z,relro -Wl,-z,now -fPIE -pie"
ENV CFLAGS="-O3 -shared-libgcc -fno-strict-overflow -fstack-protector-all -fPIC"
ENV CXXFLAGS="-O3 -shared-libgcc -fno-strict-overflow -fstack-protector-all -fPIC"
ENV LDFLAGS="-Wl,-z,relro -fPIC -pic"


ENV LIB_PREFIX=${LIB_PREFIX}
ENV FFMPEG_PATH='/usr/bin/ffmpeg'
ENV FFPROBE_PATH='/usr/bin/ffprobe'


WORKDIR /
VOLUME ["/shared"]


RUN \
    mv /etc/apt/sources.list /etc/apt/sources.list.old \
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

RUN \
    cat /proc/cpuinfo | grep ^processor | wc -l > /build_concurrency \
    && apt-get update -y && apt-get update \
    && apt-get install -y $RUNTIME_DEPS \
    && apt-get install -y $BUILD_DEPS \
    && if [ ! -z "${HTTP_PROXY}" ] ; then git config --global http.proxy ${HTTP_PROXY} && git config --global https.proxy ${HTTP_PROXY} ; fi \
    \
    && wget -O - "https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.gz" | tar xz \
    && cd nasm-2.14.02 \
    && ./configure && make -j$(cat /build_concurrency) install \
    && cd / && rm -rf nasm-2.14.02 \
    \
    && wget -O - "https://sourceforge.net/projects/lame/files/lame/$MP3LAME_VERSION/lame-$MP3LAME_VERSION.tar.gz/download" | tar xz \
    && cd lame-$MP3LAME_VERSION \
    && ./configure --enable-shared --disable-static && make -j$(cat /build_concurrency) install \
    && cd / && rm -rf lame-$MP3LAME_VERSION \
    \
    && wget -O - "https://github.com/mstorsjo/fdk-aac/archive/v$FDK_AAC_VERSION.tar.gz" | tar xz \
    && cd fdk-aac-$FDK_AAC_VERSION \
    && ./autogen.sh && ./configure --enable-shared --disable-static && make -j$(cat /build_concurrency) install \
    && cd / && rm -rf fdk-aac-$FDK_AAC_VERSION \
    \
    && wget -O - "http://downloads.xiph.org/releases/ogg/libogg-$OGG_VERSION.tar.gz" | tar xz \
    && cd libogg-$OGG_VERSION \
    && ./configure --enable-shared --disable-static && make -j$(cat /build_concurrency) install \
    && cd / && rm -rf libogg-$OGG_VERSION \
    \
    && wget -O - "https://downloads.xiph.org/releases/vorbis/libvorbis-$VORBIS_VERSION.tar.gz" | tar xz \
    && cd libvorbis-$VORBIS_VERSION \
    && ./configure --enable-shared --disable-static && make -j$(cat /build_concurrency) install \
    && cd / && rm -rf libvorbis-$VORBIS_VERSION \
    \
    && wget -O - "https://archive.mozilla.org/pub/opus/opus-$OPUS_VERSION.tar.gz" | tar xz \
    && cd opus-$OPUS_VERSION \
    && ./configure --enable-shared --disable-static && make -j$(cat /build_concurrency) install \
    && cd / && rm -rf opus-$OPUS_VERSION \
    \
    && wget -O - "https://downloads.xiph.org/releases/theora/libtheora-$THEORA_VERSION.tar.bz2" | tar xj \
    && cd libtheora-$THEORA_VERSION \
    && ./configure --enable-shared --disable-static && make -j$(cat /build_concurrency) install \
    && cd / && rm -rf libtheora-$THEORA_VERSION \
    \
    && wget -O - "https://github.com/webmproject/libvpx/archive/v$VPX_VERSION.tar.gz" | tar xz \
    && cd libvpx-$VPX_VERSION \
    && ./configure --disable-unit-tests --enable-shared --disable-static && make -j$(cat /build_concurrency) install \
    && cd / && rm -rf libvpx-$VPX_VERSION \
    \
    && git clone git://git.videolan.org/x264.git \
    && cd x264 \
    && git checkout $X264_VERSION \
    && ./configure --enable-pic --disable-static && make -j$(cat /build_concurrency) install \
    && cd / && rm -rf x264 \
    \
    && wget -O - "https://bitbucket.org/multicoreware/x265/downloads/x265_$X265_VERSION.tar.gz" | tar xz \
    && cd x265_$X265_VERSION/build/linux \
    && cmake -G "Unix Makefiles" -DENABLE_SHARED=ON -DENABLE_AGGRESSIVE_CHECKS=ON ../../source \
    && make -j$(cat /build_concurrency) install \
    && cd / && rm -rf x265_$X265_VERSION \
    \
    && wget -O - "https://github.com/webmproject/libwebp/archive/v$WEBP_VERSION.tar.gz" | tar xz \
    && cd libwebp-$WEBP_VERSION \
    && ./autogen.sh && ./configure --enable-shared --disable-static && make -j$(cat /build_concurrency) install \
    && cd / && rm -rf libwebp-$WEBP_VERSION \
    \
    && wget -O - "https://github.com/dbry/WavPack/archive/$WAVPACK_VERSION.tar.gz" | tar xz \
    && cd WavPack-$WAVPACK_VERSION \
    && ./autogen.sh && ./configure --enable-shared --disable-static && make -j$(cat /build_concurrency) install \
    && cd / && rm -rf WavPack-$WAVPACK_VERSION \
    \
    && wget -O - "https://github.com/xiph/speex/archive/Speex-$SPEEX_VERSION.tar.gz" | tar xz \
    && cd speex-Speex-$SPEEX_VERSION \
    && ./autogen.sh && ./configure --enable-shared --disable-static && make -j$(cat /build_concurrency) install \
    && cd / && rm -rf EX_VERSION \
    \
    && git clone --branch v$AOM_VERSION --depth 1 "https://aomedia.googlesource.com/aom" \
    && cd aom \
    && mkdir build_tmp && cd build_tmp \
    && cmake -DENABLE_SHARED=ON -DENABLE_TESTS=0 .. \
    && make -j$(cat /build_concurrency) install \
    && cd / && rm -rf aom \
    \
    && wget -O - "https://github.com/georgmartius/vid.stab/archive/v$VIDSTAB_VERSION.tar.gz" | tar xz \
    && cd vid.stab-$VIDSTAB_VERSION \
    && cmake -DBUILD_SHARED_LIBS=ON . \
    && make -j$(cat /build_concurrency) install \
    && cd / && rm -rf vid.stab-$VIDSTAB_VERSION \
    \
    && wget -O - "https://github.com/ultravideo/kvazaar/archive/v$KVAZAAR_VERSION.tar.gz" | tar xz \
    && cd kvazaar-$KVAZAAR_VERSION \
    && ./autogen.sh && ./configure --enable-shared --disable-static && make -j$(cat /build_concurrency) install \
    && cd / && rm -rf kvazaar-$KVAZAAR_VERSION \
    \
    && wget -O - "http://ffmpeg.org/releases/ffmpeg-$FFMPEG_VERSION.tar.gz" | tar xz \
    && cd ffmpeg-$FFMPEG_VERSION \
    && ./configure \
        --pkg-config-flags="--static" \
        --extra-libs="-lpthread -lm" \
        --toolchain=hardened \
        --disable-debug \
        --disable-ffplay \
        --disable-static \
        --enable-shared \
        --enable-pic \
        --enable-gpl \
        --enable-nonfree \
        --enable-openssl \
        --enable-iconv \
        --enable-libmp3lame \
        --enable-libfdk-aac \
        --enable-libvorbis \
        --enable-libopus \
        --enable-libtheora \
        --enable-libvpx \
        --enable-libx264 \
        --enable-libx265 \
        --enable-libwebp \
        --enable-libwavpack \
        --enable-libspeex \
        --enable-libaom \
        --enable-libvidstab \
        --enable-libkvazaar \
    && make -j$(cat /build_concurrency) install \
    && cd / && rm -rf ffmpeg-$FFMPEG_VERSION \
    \
    && wget -q http://dlib.net/files/dlib-$DLIB_VERSION.zip -O dlib-$DLIB_VERSION.zip \
    && unzip -q dlib-$DLIB_VERSION.zip && rm -rf dlib-$DLIB_VERSION.zip \
    && cd dlib-$DLIB_VERSION/examples \
    && mkdir build \
    && cd build \
    && cmake .. \
    && cmake --build . --config Release \
    && cd /dlib-$DLIB_VERSION \
    && pip3 install setuptools \
    && python3 setup.py install \
    && cd / \
    && rm -rf /dlib-$DLIB_VERSION/ \
    \
    && mkdir /opencv \
    && wget -q https://github.com/Itseez/opencv/archive/$OPENCV_VERSION.zip -O opencv-$OPENCV_VERSION.zip \
    && unzip -q opencv-$OPENCV_VERSION.zip -d /opencv && rm -rf opencv-$OPENCV_VERSION.zip \
    && wget -q https://github.com/Itseez/opencv_contrib/archive/$OPENCV_VERSION.zip -O opencv_contrib-$OPENCV_VERSION.zip \
    && unzip -q opencv_contrib-$OPENCV_VERSION.zip -d /opencv && rm -rf opencv_contrib-$OPENCV_VERSION.zip \
    && mkdir opencv/build \
    && cd opencv/build \
    opencv_cmake_flags="-D CMAKE_BUILD_TYPE=RELEASE \
                        -D INSTALL_C_EXAMPLES=OFF \
                        -D INSTALL_PYTHON_EXAMPLES=ON \
                        -D BUILD_SHARED_LIBS=OFF \
                        -D BUILD_EXAMPLES=OFF \
                        -D BUILD_DOCS=OFF \
                        -D BUILD_TESTS=OFF \
                        -D BUILD_PERF_TESTS=OFF \
                        -D BUILD_JAVA=OFF \
                        -D BUILD_NEW_PYTHON_SUPPORT=ON \
                        -D BUILD_opencv_apps=OFF \
                        -D BUILD_opencv_aruco=OFF \
                        -D BUILD_opencv_bgsegm=OFF \
                        -D BUILD_opencv_bioinspired=OFF \
                        -D BUILD_opencv_ccalib=OFF \
                        -D BUILD_opencv_datasets=OFF \
                        -D BUILD_opencv_dnn_objdetect=OFF \
                        -D BUILD_opencv_dpm=OFF \
                        -D BUILD_opencv_fuzzy=OFF \
                        -D BUILD_opencv_hfs=OFF \
                        -D BUILD_opencv_java_bindings_generator=OFF \
                        -D BUILD_opencv_js=OFF \
                        -D BUILD_opencv_img_hash=OFF \
                        -D BUILD_opencv_line_descriptor=OFF \
                        -D BUILD_opencv_optflow=OFF \
                        -D BUILD_opencv_phase_unwrapping=OFF \
                        -D BUILD_opencv_python2=OFF \
                        -D BUILD_opencv_python3=ON \
                        -D BUILD_opencv_python_bindings_generator=OFF \
                        -D BUILD_opencv_reg=OFF \
                        -D BUILD_opencv_rgbd=OFF \
                        -D BUILD_opencv_saliency=OFF \
                        -D BUILD_opencv_shape=OFF \
                        -D BUILD_opencv_stereo=OFF \
                        -D BUILD_opencv_stitching=OFF \
                        -D BUILD_opencv_structured_light=OFF \
                        -D BUILD_opencv_superres=OFF \
                        -D BUILD_opencv_surface_matching=OFF \
                        -D BUILD_opencv_ts=OFF \
                        -D BUILD_opencv_xobjdetect=OFF \
                        -D BUILD_opencv_xphoto=OFF \
                        -D WITH_VTK=OFF \
                        -D WITH_FFMPEG=1 \
                        -D WITH_CUDA=0 \
                        -D CMAKE_INSTALL_PREFIX=$LIB_PREFIX \
                        -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-${OPENCV_VERSION}/modules" \
    && cmake $opencv_cmake_flags .. \
    && make -j$(cat /build_concurrency) \
    && cd /opencv/opencv/build \
    && make install \
    && cd / \
    && rm -rf /opencv \
    \
    && /usr/glibc-compat/sbin/ldconfig \
    && AUTO_ADDED_PACKAGES='apt-mark showauto' \
    && apt-get remove --purge -y $BUILD_DEPS $AUTO_ADDED_PACKAGES \
    && apt-get install -y $RUNTIME_DEPS \
    && rm -rf /var/lib/apt/lists/* \
    && git config --unset http.proxy \
    && git config --unset https.proxy

RUN \
    echo \
    "{" \
    "\"ffmpeg\": \"$FFMPEG_VERSION\"," \
    "\"libmp3lame\": \"$MP3LAME_VERSION\"," \
    "\"libfdk-aac\": \"$FDK_AAC_VERSION\"," \
    "\"libogg\": \"$OGG_VERSION\"," \
    "\"libvorbis\": \"$VORBIS_VERSION\"," \
    "\"libopus\": \"$OPUS_VERSION\"," \
    "\"libtheora\": \"$THEORA_VERSION\"," \
    "\"libvpx\": \"$VPX_VERSION\"," \
    "\"libx264\": \"$X264_VERSION\"," \
    "\"libx265\": \"$X265_VERSION\"," \
    "\"libwebp\": \"$WEBP_VERSION\"," \
    "\"libwavpack\": \"$WAVPACK_VERSION\"," \
    "\"libspeex\": \"$SPEEX_VERSION\"," \
    "\"libaom\": \"$AOM_VERSION\"," \
    "\"libvidstab\": \"$VIDSTAB_VERSION\"," \
    "\"libkvazaar\": \"$KVAZAAR_VERSION\"," \
    "\"opencv\": \"$OPENCV_VERSION\"," \
    "\"dlib\": \"$DLIB_VERSION\"" \
    "}" \
    | jq . > /versions.json


# ADD $PWD/requirements.txt /requirements.txt
# RUN pip3 install -r /requirements.txt


CMD ["/bin/bash"]
