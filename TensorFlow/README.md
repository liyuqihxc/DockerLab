# Tensorflow + OpenCV + DLib

#### FFmpeg compile options

```
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
```

#### OpenCV compile options

```
-D CMAKE_BUILD_TYPE=RELEASE
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
```