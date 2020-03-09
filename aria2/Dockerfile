FROM alpine:3.11

ARG ARIA2_VERSION=1.35.0-r0
ARG NG_VERSION=1.1.4

ADD entrypoint.sh aria2.conf /aria2/

RUN set -x \
    && sed -i 's/http:\/\/dl-cdn.alpinelinux.org/https:\/\/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk add --no-cache --update aria2=${ARIA2_VERSION} darkhttpd \
    \
    && wget -q https://github.com/mayswind/AriaNg/releases/download/${NG_VERSION}/AriaNg-${NG_VERSION}.zip -O /AriaNg-${NG_VERSION}.zip \
    && mkdir /aria2/AriaNg \
    && unzip -q /AriaNg-${NG_VERSION}.zip -d /aria2/AriaNg \
    && rm -rf /AriaNg-${NG_VERSION}.zip \
    \
    && rm -rf /tmp/* /var/cache/apk/*

WORKDIR /aria2

RUN chmod +x entrypoint.sh

VOLUME [ "downloads/" ]
VOLUME [ "data/" ]
VOLUME [ "on-complete.sh" ]

EXPOSE 6800 6801

ENTRYPOINT [ "sh", "entrypoint.sh" ]
