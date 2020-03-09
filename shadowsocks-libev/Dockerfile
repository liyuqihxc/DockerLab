FROM golang:alpine as builder

ARG V2RAY_VERSION=1.3.0

RUN sed -i 's/http:\/\/dl-cdn.alpinelinux.org/https:\/\/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk add git \
    && mkdir /v2ray \
    && cd /v2ray \
    && git clone https://github.com/shadowsocks/v2ray-plugin.git . \
    && git checkout tags/v${V2RAY_VERSION}

RUN cd /v2ray \
    && go env -w GOPROXY=https://goproxy.io,direct \
    && go build

FROM nginx:stable-alpine

ARG SS_VERSION=3.3.4

COPY --from=builder /v2ray/v2ray-plugin /usr/bin/v2ray-plugin

RUN \
    set -ex \
    && sed -i 's/http:\/\/dl-cdn.alpinelinux.org/https:\/\/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    # Build environment setup
    && apk add --no-cache --virtual .build-deps \
    git \
    autoconf \
    automake \
    build-base \
    c-ares-dev \
    libev-dev \
    libtool \
    libsodium-dev \
    linux-headers \
    mbedtls-dev \
    pcre-dev \
    # Build & install
    && cat /proc/cpuinfo | grep ^processor | wc -l > /build_concurrency \
    && git clone https://github.com/shadowsocks/shadowsocks-libev.git \
    && cd shadowsocks-libev \
    && git checkout v$SS_VERSION \
    && git submodule update --init --recursive \
    && ./autogen.sh \
    && ./configure --prefix=/usr --disable-documentation \
    && make -j$(cat /build_concurrency) install \
    && cd / && rm -rf shadowsocks-libev \
    && mkdir /etc/shadowsocks-libev \
    && apk del .build-deps \
    && rm -rf /build_concurrency \
    # Runtime dependencies setup
    && apk add --no-cache \
    rng-tools \
    $(scanelf --needed --nobanner /usr/bin/ss-* \
    | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
    | sort -u) \
    && rm -rf /tmp/* /var/cache/apk/*

VOLUME [ "/etc/nginx/certs" ]

EXPOSE 443 18650

COPY v2ray.conf /etc/nginx/conf.d
COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
