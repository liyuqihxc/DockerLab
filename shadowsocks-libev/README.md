# shadowsocks-libev

[https://github.com/shadowsocks/shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev)

#### How to use

```
docker pull liyuqihxc/shadowsocks-libev

docker run -d --rm -p 443:443/tcp -v $(pwd):/etc/nginx/certs liyuqihxc/shadowsocks-libev:3.3.4-v2ray -s -d mydomain.com -p password

docker run -d --rm -p 18650:18650/tcp -v $(pwd):/etc/nginx/certs liyuqihxc/shadowsocks-libev:3.3.4-v2ray -c -d mydomain.com -p password -e ca.crt
```

#### Build

```bash
docker build -t shadowsocks-libev .
```
