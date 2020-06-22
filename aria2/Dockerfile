FROM alpine:3.11

ARG ARIA2_VERSION=1.35.0-r0
ARG NG_VERSION=1.1.4

# 6800 rpc-listen-port
ARG RPC_LISTEN_PORT=6800
# 6801 AriaNg http server
ARG HTTP_LISTEN_PORT=6801
# 6881-6999 dht-listen-port/udp listen-port/tcp
ARG BT_LISTEN_PORT=6881-6999

RUN set -x \
    && sed -i 's/http:\/\/dl-cdn.alpinelinux.org/https:\/\/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk add --no-cache --update aria2=${ARIA2_VERSION} darkhttpd miniupnpc \
    \
    && wget -q https://github.com/mayswind/AriaNg/releases/download/${NG_VERSION}/AriaNg-${NG_VERSION}.zip -O /AriaNg-${NG_VERSION}.zip \
    && mkdir /aria2/AriaNg \
    && unzip -q /AriaNg-${NG_VERSION}.zip -d /aria2/AriaNg \
    && rm -rf /AriaNg-${NG_VERSION}.zip \docker \
    \
    && rm -rf /tmp/* /var/cache/apk/*

WORKDIR /aria2
COPY entrypoint.sh ./
COPY aria2.conf data/

RUN chmod +x entrypoint.sh && \
    sed -i "s/^rpc-listen-port.*$/rpc-listen-port=$RPC_LISTEN_PORT/g" /aria2/data/aria2.conf && \
    sed -i "s/^listen-port.*$/listen-port=$BT_LISTEN_PORT/g" /aria2/data/aria2.conf && \
    sed -i "s/^dht-listen-port.*$/dht-listen-port=$BT_LISTEN_PORT/g" /aria2/data/aria2.conf

VOLUME [ "downloads/" ]
VOLUME [ "data/" ]

EXPOSE $RPC_LISTEN_PORT/tcp $HTTP_LISTEN_PORT/tcp $BT_LISTEN_PORT

ENTRYPOINT [ "sh", "entrypoint.sh" ]
