#!usr/bin/env sh

show_help() {
  echo ""
  echo "Usage:"
  echo "  docker run -it liyuqihxc/shadowsocks-libev[:tag] [options]"
  echo ""
  echo "Options:"
  echo "  -d         域名"
  echo "  -p         密码"
  echo "  -m         加密算法"
  echo "  -t         超时间隔"
  echo "  -a         DNS地址"
  echo "  -h         显示帮助信息并退出"
  echo ""
  echo "Example:"
  echo "  docker run -it liyuqihxc/shadowsocks-libev[:tag] -s mydomain.com"
  echo ""
  exit 0
}

TIMEOUT="60"
METHOD="aes-256-gcm"
DNS_ADDRS="8.8.8.8,8.8.4.4"

while getopts 's:p:t:m:a:' OPT; do
  case $OPT in
    s)
      SERVER_NAME="$OPTARG";;
    p)
      PASSWORD="$OPTARG";;
    t)
      TIMEOUT="$OPTARG";;
    m)
      METHOD="$OPTARG";;
    a)
      DNS_ADDRS="$OPTARG";;
    h)
      show_help;;
    ?)
      show_help
  esac
done
  
shift $(($OPTIND - 1))

[ -z $SERVER_NAME ] && echo "初始化必须设置域名。" && show_help
[ -z $PASSWORD ] && echo "初始化必须设置密码。" && show_help

echo "{
  \"server\": \"127.0.0.1\",
  \"server_port\": \"18650\",
  \"password\": \"${PASSWORD}\",
  \"timeout\": \"${TIMEOUT}\",
  \"method\": \"${METHOD}\",
  \"fast_open\": true,
  \"plugin\": \"v2ray-plugin\",
  \"plugin_opts\": \"server;path=/v2ray;loglevel=none\"
}" > /etc/shadowsocks-libev/config.json

sed -i 's@%SERVER_NAME%@'"${SERVER_NAME}"'@' /etc/nginx/nginx.conf

ss-server -c /etc/shadowsocks-libev/config.json -u -d ${DNS_ADDRS}
