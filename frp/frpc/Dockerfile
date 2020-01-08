FROM golang:alpine as builder

ARG FRP_VERSION=v0.31.1

RUN sed -i 's/http:\/\/dl-cdn.alpinelinux.org/https:\/\/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk add --update git make

RUN mkdir /frp \
    && cd /frp \
    && git clone https://github.com/fatedier/frp.git . \
    && git checkout tags/${FRP_VERSION} \
    && make

FROM alpine:3.11

WORKDIR /frpc

COPY --from=builder /frp/bin/frpc ./

VOLUME ["/frpc/frpc.ini"]

ENTRYPOINT [ "./frpc", "-c", "frpc.ini" ]
