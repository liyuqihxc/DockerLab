FROM microsoft/dotnet:2.2-sdk-alpine as builder

ARG BAGET_VERSION="0.1.54-prerelease"
ARG NVM_VERSION="0.34.0"
ARG BAGET_PORT=8000
ARG BAGET_DIR="/var/baget"

RUN set -ex \
    && sed -i 's/http:\/\/dl-cdn.alpinelinux.org/https:\/\/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk add git wget nodejs nodejs-npm

RUN git clone https://github.com/loic-sharma/BaGet.git \
    && cd BaGet \
    && git checkout v${BAGET_VERSION}

RUN cd BaGet/src \
    && dotnet restore BaGet \
    && dotnet build BaGet -c Release --no-restore \
    && dotnet publish BaGet -c Release --no-restore --no-build -o Publish \
    && echo -e "{\"urls\": \"http://*:${BAGET_PORT}\"}" > Publish/hosting.json


FROM microsoft/dotnet:2.2.2-aspnetcore-runtime-alpine3.8

ENV Storage__Type="FileSystem" \
    Storage__Path="${BAGET_DIR}/packages" \
    Database__Type="Sqlite" \
    Database__ConnectionString="Data Source=${BAGET_DIR}/baget.db" \
    Search__Type="Database"

COPY --from=builder /BaGet/Publish /baget

WORKDIR /baget

VOLUME ["${BAGET_DIR}"]

EXPOSE ${BAGET_PORT}

ENTRYPOINT ["dotnet", "BaGet.dll"]
