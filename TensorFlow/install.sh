#!usr/bin/env bash

set -x
cat /proc/cpuinfo | grep ^processor | wc -l > /build_concurrency
apt update && apt upgrade -y
apt install -y ${BUILD_DEPS}
pip install --upgrade pip

echo \
"{
    \"ffmpeg\": \"${FFMPEG_VERSION}\",
    \"libmp3lame\": \"${MP3LAME_VERSION}\",
    \"libfdk-aac\": \"${FDK_AAC_VERSION}\",
    \"libogg\": \"${OGG_VERSION}\",
    \"libvorbis\": \"${VORBIS_VERSION}\",
    \"libopus\": \"${OPUS_VERSION}\",
    \"libtheora\": \"${THEORA_VERSION}\",
    \"libvpx\": \"${VPX_VERSION}\",
    \"libx264\": \"${X264_VERSION}\",
    \"libx265\": \"${X265_VERSION}\",
    \"libwebp\": \"${WEBP_VERSION}\",
    \"libwavpack\": \"${WAVPACK_VERSION}\",
    \"libspeex\": \"${SPEEX_VERSION}\",
    \"libaom\": \"${AOM_VERSION}\",
    \"libvidstab\": \"${VIDSTAB_VERSION}\",
    \"libkvazaar\": \"${KVAZAAR_VERSION}\",
    \"opencv\": \"${OPENCV_VERSION}\",
    \"dlib\": \"${DLIB_VERSION}\"
}" | jq . > /versions.json

wget -q -O - https://www.nasm.us/pub/nasm/releasebuilds/${NASM_VERSION}/nasm-${NASM_VERSION}.tar.gz | tar xz -C /
cd /nasm-${NASM_VERSION}
./configure && make -j$(cat /build_concurrency) install

sh -c "wget -q -O - https://sourceforge.net/projects/lame/files/lame/${MP3LAME_VERSION}/lame-${MP3LAME_VERSION}.tar.gz/download | tar xz -C /
cd /lame-${MP3LAME_VERSION}
./configure --enable-shared --disable-static
make -j$(cat /build_concurrency) install
rm -rf /lame-${MP3LAME_VERSION}"&

sh -c "wget -q -O - https://github.com/mstorsjo/fdk-aac/archive/v${FDK_AAC_VERSION}.tar.gz | tar xz -C /
cd /fdk-aac-${FDK_AAC_VERSION}
./autogen.sh && ./configure --enable-shared --disable-static
make -j$(cat /build_concurrency) install
rm -rf /fdk-aac-${FDK_AAC_VERSION}"&

sh -c "wget -q -O - http://downloads.xiph.org/releases/ogg/libogg-${OGG_VERSION}.tar.gz | tar xz -C /
cd /libogg-${OGG_VERSION}
./configure --enable-shared --disable-static
make -j$(cat /build_concurrency) install
rm -rf /libogg-${OGG_VERSION}"&

sh -c "wget -q -O - https://downloads.xiph.org/releases/vorbis/libvorbis-${VORBIS_VERSION}.tar.gz | tar xz -C /
cd /libvorbis-${VORBIS_VERSION}
./configure --enable-shared --disable-static
make -j$(cat /build_concurrency) install
rm -rf /libvorbis-${VORBIS_VERSION}"&

sh -c "wget -q -O - https://archive.mozilla.org/pub/opus/opus-${OPUS_VERSION}.tar.gz | tar xz -C /
cd /opus-${OPUS_VERSION}
./configure --enable-shared --disable-static
make -j$(cat /build_concurrency) install
rm -rf /opus-${OPUS_VERSION}"&

sh -c "wget -q -O - https://downloads.xiph.org/releases/theora/libtheora-${THEORA_VERSION}.tar.bz2 | tar xj -C /
cd /libtheora-${THEORA_VERSION}
./configure --enable-shared --disable-static
make -j$(cat /build_concurrency) install
rm -rf /libtheora-${THEORA_VERSION}"&

sh -c "wget -q -O - https://github.com/webmproject/libvpx/archive/v${VPX_VERSION}.tar.gz | tar xz -C /
cd /libvpx-${VPX_VERSION}
./configure --disable-unit-tests --enable-shared --disable-static
make -j$(cat /build_concurrency) install
rm -rf /libvpx-${VPX_VERSION}"&

sh -c "cd /
git clone https://code.videolan.org/videolan/x264.git
cd /x264
git checkout ${X264_VERSION}
./configure --enable-pic --enable-shared --disable-static
make -j$(cat /build_concurrency) install
rm -rf /x264"&

sh -c "wget -q -O - http://ftp.videolan.org/pub/videolan/x265/x265_${X265_VERSION}.tar.gz | tar xz -C /
cd /x265_${X265_VERSION}/build/linux
cmake -G \"Unix Makefiles\" -DENABLE_SHARED=ON -DENABLE_AGGRESSIVE_CHECKS=ON ../../source
make -j$(cat /build_concurrency) install
rm -rf /x265_${X265_VERSION}"&

sh -c "wget -q -O - https://github.com/webmproject/libwebp/archive/v${WEBP_VERSION}.tar.gz | tar xz -C /
cd /libwebp-${WEBP_VERSION}
./autogen.sh && ./configure --enable-shared --disable-static
make -j$(cat /build_concurrency) install
rm -rf /libwebp-${WEBP_VERSION}"&

sh -c "wget -q -O - https://github.com/dbry/WavPack/archive/${WAVPACK_VERSION}.tar.gz | tar xz -C /
cd /WavPack-${WAVPACK_VERSION}
./autogen.sh && ./configure --enable-shared --disable-static
make -j$(cat /build_concurrency) install
rm -rf /WavPack-${WAVPACK_VERSION}"&

sh -c "wget -q -O - https://github.com/xiph/speex/archive/Speex-${SPEEX_VERSION}.tar.gz | tar xz -C /
cd /speex-Speex-${SPEEX_VERSION}
./autogen.sh && ./configure --enable-shared --disable-static
make -j$(cat /build_concurrency) install
rm -rf /speex-Speex-${SPEEX_VERSION}"&

sh -c "cd /
git clone --branch v${AOM_VERSION} --depth 1 https://github.com/liyuqihxc/aom.git
mkdir /aom/build_tmp && cd /aom/build_tmp
cmake -DBUILD_SHARED_LIBS=1 -DENABLE_TESTS=0 ..
make -j$(cat /build_concurrency) install
rm -rf /aom"&

sh -c "wget -q -O - https://github.com/georgmartius/vid.stab/archive/v${VIDSTAB_VERSION}.tar.gz | tar xz -C /
cd /vid.stab-${VIDSTAB_VERSION}
cmake -DBUILD_SHARED_LIBS=ON .
make -j$(cat /build_concurrency) install
rm -rf /vid.stab-${VIDSTAB_VERSION}"&

sh -c "wget -q -O - https://github.com/ultravideo/kvazaar/archive/v${KVAZAAR_VERSION}.tar.gz | tar xz -C /
cd /kvazaar-${KVAZAAR_VERSION}
./autogen.sh && ./configure --enable-shared --disable-static
make -j$(cat /build_concurrency) install
rm -rf /kvazaar-${KVAZAAR_VERSION}"&

wait %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 %13 %14 %15

wget -q -O - http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz | tar xz -C /
cd /ffmpeg-${FFMPEG_VERSION}
./configure
    --pkg-config-flags="--static"
    --extra-libs="-lpthread -lm"
    --toolchain=hardened
    --disable-debug
    --disable-ffplay
    --disable-static
    --enable-shared
    --enable-pic
    --enable-gpl
    --enable-nonfree
    --enable-openssl
    --enable-iconv
    --enable-libmp3lame
    --enable-libfdk-aac
    --enable-libvorbis
    --enable-libopus
    --enable-libtheora
    --enable-libvpx
    --enable-libx264
    --enable-libx265
    --enable-libwebp
    --enable-libwavpack
    --enable-libspeex
    --enable-libaom
    --enable-libvidstab
    --enable-libkvazaar
make -j$(cat /build_concurrency) install
rm -rf /ffmpeg-${FFMPEG_VERSION}

wget -q -O - http://dlib.net/files/dlib-${DLIB_VERSION}.tar.bz2 | tar xj -C /
cd /dlib-${DLIB_VERSION}/examples
mkdir build
cd build
cmake ..
cmake --build . --config Release
cd /dlib-${DLIB_VERSION}
pip3 install setuptools
python3 setup.py install
rm -rf /dlib-${DLIB_VERSION}

wget -q https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip -O /opencv-${OPENCV_VERSION}.zip
unzip -q /opencv-${OPENCV_VERSION}.zip && rm -rf /opencv-${OPENCV_VERSION}.zip
wget -q https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip -O /opencv_contrib-${OPENCV_VERSION}.zip
unzip -q /opencv_contrib-${OPENCV_VERSION}.zip -d /opencv-${OPENCV_VERSION} && rm -rf /opencv_contrib-${OPENCV_VERSION}.zip
mkdir /opencv-${OPENCV_VERSION}/build
cd /opencv-${OPENCV_VERSION}/build
opencv_cmake_flags="-D CMAKE_BUILD_TYPE=RELEASE
                    -D INSTALL_C_EXAMPLES=OFF
                    -D INSTALL_PYTHON_EXAMPLES=ON
                    -D BUILD_SHARED_LIBS=OFF
                    -D BUILD_EXAMPLES=OFF
                    -D BUILD_DOCS=OFF
                    -D BUILD_TESTS=OFF
                    -D BUILD_PERF_TESTS=OFF
                    -D BUILD_JAVA=OFF
                    -D BUILD_NEW_PYTHON_SUPPORT=ON
                    -D BUILD_opencv_apps=OFF
                    -D BUILD_opencv_aruco=OFF
                    -D BUILD_opencv_bgsegm=OFF
                    -D BUILD_opencv_bioinspired=OFF
                    -D BUILD_opencv_ccalib=OFF
                    -D BUILD_opencv_datasets=OFF
                    -D BUILD_opencv_dnn_objdetect=OFF
                    -D BUILD_opencv_dpm=OFF
                    -D BUILD_opencv_fuzzy=OFF
                    -D BUILD_opencv_hfs=OFF
                    -D BUILD_opencv_java_bindings_generator=OFF
                    -D BUILD_opencv_js=OFF
                    -D BUILD_opencv_img_hash=OFF
                    -D BUILD_opencv_line_descriptor=OFF
                    -D BUILD_opencv_optflow=OFF
                    -D BUILD_opencv_phase_unwrapping=OFF
                    -D BUILD_opencv_python2=OFF
                    -D BUILD_opencv_python3=ON
                    -D BUILD_opencv_python_bindings_generator=OFF
                    -D BUILD_opencv_reg=OFF
                    -D BUILD_opencv_rgbd=OFF
                    -D BUILD_opencv_saliency=OFF
                    -D BUILD_opencv_shape=OFF
                    -D BUILD_opencv_stereo=OFF
                    -D BUILD_opencv_stitching=OFF
                    -D BUILD_opencv_structured_light=OFF
                    -D BUILD_opencv_superres=OFF
                    -D BUILD_opencv_surface_matching=OFF
                    -D BUILD_opencv_ts=OFF
                    -D BUILD_opencv_xobjdetect=OFF
                    -D BUILD_opencv_xphoto=OFF
                    -D WITH_VTK=OFF
                    -D WITH_FFMPEG=1
                    -D WITH_CUDA=0
                    -D OPENCV_EXTRA_MODULES_PATH= /opencv-${OPENCV_VERSION}/opencv_contrib-${OPENCV_VERSION}/modules"
cmake $opencv_cmake_flags ..
make -j$(cat /build_concurrency)
cd /opencv-${OPENCV_VERSION}/build
make install
echo "/usr/local/lib" >> /etc/ld.so.conf.d/opencv.conf
ldconfig
rm -rf /opencv-${OPENCV_VERSION}

cd /nasm-${NASM_VERSION}
make uninstall
rm -rf /nasm-${NASM_VERSION}

apt purge ${BUILD_DEPS}
apt install -y ${RUNTIME_DEPS}
apt autoremove
rm -rf /var/lib/apt/lists/*

pip3 install -r /requirements.txt
