FROM golang:alpine as builder

ARG V2RAY_VERSION=1.3.0

RUN mkdir /v2ray \
    && cd /v2ray \
    && git clone https://github.com/shadowsocks/v2ray-plugin.git . \
    && git checkout tags/v${V2RAY_VERSION} \
    && go build \
    && curl https://get.acme.sh | sh \
    && ls -la

FROM nginx:stable-alpine

ARG SS_VERSION=3.3.4

ENV SERVER_ADDR=0.0.0.0
ENV SERVER_ADDR_IPV6=::0
ENV SERVER_PORT=18650
ENV PASSWORD=
ENV METHOD=aes-256-gcm
ENV TIMEOUT=60
ENV DNS_ADDRS=8.8.8.8,8.8.4.4

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

CMD exec ss-server \
    -s ${SERVER_ADDR} \
    -s ${SERVER_ADDR_IPV6} \
    -p ${SERVER_PORT} \
    -k ${PASSWORD} \
    -m ${METHOD} \
    -t ${TIMEOUT} \
    --fast-open \
    -d $DNS_ADDRS \
    -u \
    $ARGS
