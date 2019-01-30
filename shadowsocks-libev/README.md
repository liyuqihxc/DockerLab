# shadowsocks-libev

[https://github.com/shadowsocks/shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev)

#### How to use

```bash
docker pull liyuqihxc/shadowsocks-libev

echo PASSWORD=<server-password> >> .envfile

echo METHOD=<server-encrypt-method> >> .envfile

docker run -d -p <server-port>:18650/tcp -p <server-port>:18650/udp --env-file ./.envfile liyuqihxc/shadowsocks-libev
```

#### Build

```bash
docker build -t shadowsocks-libev .
```