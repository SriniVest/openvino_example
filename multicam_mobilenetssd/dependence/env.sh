#!/bin/bash
if [ -n "$1" ]; then
    export export YAMI_ROOT_DIR=$1
else
    export YAMI_ROOT_DIR="/opt/yami"
fi

export FFMPEG_PREFIX="/opt/ffmpeg"
export VAAPI_PREFIX="${YAMI_ROOT_DIR}/vaapi"
export LIBYAMI_PREFIX="${YAMI_ROOT_DIR}/libyami"

ADD_PKG_CONFIG_PATH="${VAAPI_PREFIX}/lib/pkgconfig/:${LIBYAMI_PREFIX}/lib/pkgconfig/:${FFMPEG_PREFIX}/lib/pkgconfig/"
ADD_LD_LIBRARY_PATH="${VAAPI_PREFIX}/lib/:${LIBYAMI_PREFIX}/lib/:${FFMPEG_PREFIX}/lib/"
ADD_PATH="${VAAPI_PREFIX}/bin/:${LIBYAMI_PREFIX}/bin/:${FFMPEG_PREFIX}/bin/"

PLATFORM_ARCH_64=`uname -a | grep x86_64`
if [ -n "$PKG_CONFIG_PATH" ]; then
    export PKG_CONFIG_PATH="${ADD_PKG_CONFIG_PATH}:$PKG_CONFIG_PATH"
elif [ -n "$PLATFORM_ARCH_64" ]; then
    export PKG_CONFIG_PATH="${ADD_PKG_CONFIG_PATH}:/usr/lib/pkgconfig/:/usr/lib/i386-linux-gnu/pkgconfig/"
else
    export PKG_CONFIG_PATH="${ADD_PKG_CONFIG_PATH}:/usr/lib/pkgconfig/:/usr/lib/x86_64-linux-gnu/pkgconfig/"
fi

export LD_LIBRARY_PATH="${ADD_LD_LIBRARY_PATH}:$LD_LIBRARY_PATH"

export PATH="${ADD_PATH}:$PATH"

echo "*======================current configuration============================="
echo "* VAAPI_PREFIX:               $VAAPI_PREFIX"
echo "* LIBYAMI_PREFIX:             ${LIBYAMI_PREFIX}"
echo "* FFMPEG_PREFIX:              ${FFMPEG_PREFIX}"
echo "* LD_LIBRARY_PATH:            ${LD_LIBRARY_PATH}"
echo "* PATH:                       $PATH"
echo "*========================================================================="

echo "* libva & intel-driver:      git clean -dxf && ./autogen.sh --prefix=\$VAAPI_PREFIX && make -j8 && make install"
echo "* libyami:    git clean -dxf && ./autogen.sh --prefix=\$LIBYAMI_PREFIX --enable-tests --enable-mpeg2dec --enable-vc1dec  && make -j8 && make install"
echo "* ffmpeg_libyami:     git clean -dxf && ./configure --prefix=\$FFMPEG_PREFIX --enable-libyami --disable-doc --disable-stripping  --enable-debug=3 --enable-version3 && make -j8 && make install"

