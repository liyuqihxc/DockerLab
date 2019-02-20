FROM microsoft/dotnet:2.2-sdk as builder

ARG BAGET_VERSION="0.1.54-prerelease"
ARG NVM_VERSION="0.34.0"

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak \
    && echo "deb http://mirrors.163.com/debian/ stretch main non-free contrib"                       >> /etc/apt/sources.list \
    && echo "deb http://mirrors.163.com/debian/ stretch-updates main non-free contrib"               >> /etc/apt/sources.list \
    && echo "deb http://mirrors.163.com/debian/ stretch-backports main non-free contrib"             >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.163.com/debian/ stretch main non-free contrib"                   >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.163.com/debian/ stretch-updates main non-free contrib"           >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.163.com/debian/ stretch-backports main non-free contrib"         >> /etc/apt/sources.list \
    && echo "deb http://mirrors.163.com/debian-security/ stretch/updates main non-free contrib"      >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.163.com/debian-security/ stretch/updates main non-free contrib"  >> /etc/apt/sources.list \
    && apt-get update -y && apt-get update \
    && apt-get install -y git wget \
    && wget -O- "https://deb.nodesource.com/setup_8.x" | bash - \
    && apt-get install -y nodejs

RUN git clone https://github.com/loic-sharma/BaGet.git \
    && cd BaGet \
    && git checkout v${BAGET_VERSION}

RUN cd BaGet/src \
    && dotnet restore BaGet \
    && dotnet build BaGet -c Release --no-restore \
    && dotnet publish BaGet -c Release --no-restore --no-build -o /Publish


FROM microsoft/dotnet:2.2-aspnetcore-runtime

ARG BAGET_DIR="/var/baget"

ENV Storage__Path="${BAGET_DIR}/packages" \
    Database__ConnectionString="Data Source=${BAGET_DIR}/baget.db"

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

COPY --from=builder /Publish /baget

WORKDIR /baget

VOLUME ["${BAGET_DIR}"]

EXPOSE 80

ENTRYPOINT [ "dotnet", "BaGet.dll"]
