FROM microsoft/dotnet:2.2.2-aspnetcore-runtime-alpine3.8

ARG BAGET_VERSION="0.1.54-prerelease"
ARG BAGET_PORT=8000
ARG BAGET_DIR="/var/baget"

ENV ApiKey=
ENV Storage__Type=FileSystem
ENV Storage__Path=${BAGET_DIR}/packages
ENV Database__Type=Sqlite
ENV Database__ConnectionString=Data Source=${BAGET_DIR}/baget.db
ENV Search__Type=Database

RUN \
    set -ex \
    && sed -i 's/http:\/\/dl-cdn.alpinelinux.org/https:\/\/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    # Build environment setup
    && apk add --no-cache --virtual .build-deps wget unzip \
    # Download BaGet
    && wget -O BaGet.zip https://github.com/loic-sharma/BaGet/releases/download/v${BAGET_VERSION}/BaGet.zip \
    && unzip BaGet.zip -d /baget && rm -rf BaGet.zip \
    && echo -e "{\"urls\": \"http://*:${BAGET_PORT}\"}" > /baget.json \
    && apk del .build-deps \
    && rm -rf /tmp/* /var/cache/apk/*

WORKDIR /baget

VOLUME ["${BAGET_DIR}"]

EXPOSE ${BAGET_PORT}

ENTRYPOINT ["dotnet", "BaGet.dll"]
