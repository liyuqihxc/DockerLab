# shadowsocks-libev

[https://github.com/shadowsocks/shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev)

#### How to use

```
docker pull liyuqihxc/shadowsocks-libev

docker run -d --rm -p 443:443/tcp -v $(pwd):/etc/nginx/certs liyuqihxc/shadowsocks-libev:3.3.4-v2ray -d mydomain.com -p password
```

#### Build

```bash
docker build -t shadowsocks-libev .
```
