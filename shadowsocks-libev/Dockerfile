FROM golang:alpine as builder

ARG V2RAY_VERSION=1.3.0

ENV SERVER_NAME=0.0.0.0

RUN apk add git \
    && mkdir /v2ray \
    && cd /v2ray \
    && git clone https://github.com/shadowsocks/v2ray-plugin.git . \
    && git checkout tags/v${V2RAY_VERSION}

RUN cd /v2ray \
    &&go build

FROM nginx:stable-alpine

ARG SS_VERSION=3.3.4

ENV SERVER_NAME=0.0.0.0
ENV PASSWORD=
ENV METHOD=aes-256-gcm
ENV TIMEOUT=60
ENV DNS_ADDRS=8.8.8.8,8.8.4.4

COPY --from=builder /v2ray/v2ray-plugin /usr/bin/v2ray-plugin
COPY nginx.conf /etc/nginx/nginx.conf

RUN \
    set -ex \
    && sed -i 's/http:\/\/dl-cdn.alpinelinux.org/https:\/\/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    # Build environment setup
    && apk add --no-cache --virtual .build-deps \
    jq \
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
    && echo "{ \
    \"server\": \"0.0.0.0\", \
    \"server_port\": \"18650\", \
    \"password\": \"${PASSWORD}\", \
    \"timeout\": \"${TIMEOUT}\", \
    \"method\": \"${METHOD}\", \
    \"fast_open\": true, \
    \"plugin\": \"v2ray-plugin\", \
    \"plugin_opts\": \"server;path=/v2ray;loglevel=none\" \
    }" | jq . > /etc/shadowsocks-libev/config.json \
    && apk del .build-deps \
    && rm -rf /build_concurrency \
    # Runtime dependencies setup
    && apk add --no-cache \
    rng-tools \
    $(scanelf --needed --nobanner /usr/bin/ss-* \
    | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
    | sort -u) \
    && rm -rf /tmp/* /var/cache/apk/*

USER nobody

VOLUME [ "/etc/nginx" ]

RUN \
    && sed -i 's@%SERVER_NAME%@'"${SERVER_NAME}"'@' /etc/nginx/nginx.conf

ENTRYPOINT [ "ss-server", "-c", "/etc/shadowsocks-libev/config.json", "-u", "-d", "${DNS_ADDRS}", "-f", "/run/shadowsocks.pid" ]
