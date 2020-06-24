FROM node:lts-alpine

WORKDIR /ip_notifier

COPY ./* ./

RUN set -ex \
    && sed -i 's/http:\/\/dl-cdn.alpinelinux.org/https:\/\/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && yarn install

EXPOSE 50001

VOLUME [ "_config" ]

ENTRYPOINT [ "node", "index.js" ]
