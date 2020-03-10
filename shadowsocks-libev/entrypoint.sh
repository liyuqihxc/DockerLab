#!usr/bin/env sh

show_help() {
  echo ""
  echo "Usage:"
  echo "  docker run [docker_opts] liyuqihxc/shadowsocks-libev[:tag] [options]"
  echo ""
  echo "Options:"
  echo "  -s, --server           作为Server端启动"
  echo "  -c, --client           作为Client端启动"
  echo "  -x, --mux              并发连接数，仅在Client端可用"
  echo "  -d, --server-name      域名"
  echo "  -p, --password         密码"
  echo "  -m, --method           加密算法"
  echo "  -t, --timeout          超时间隔"
  echo "  -a, --dns-address      DNS地址，仅在Server端可用"
  echo "  -h, --help             显示帮助信息并退出"
  echo ""
  echo "Example:"
  echo "  作为Server端启动:"
  echo "    docker run [docker_opts] liyuqihxc/shadowsocks-libev[:tag] -s -d mydomain.com -p password"
  echo "  作为Client端启动:"
  echo "    docker run [docker_opts] liyuqihxc/shadowsocks-libev[:tag] -c -d mydomain.com -p password -x 5"
  echo ""
  exit 0
}

RUNAS_SERVER=false
RUNAS_CLIENT=false
MUX=3
TIMEOUT=300
METHOD="aes-256-gcm"
DNS_ADDRS="8.8.8.8,8.8.4.4"

ARGS=`getopt -a -o scx::d:p:m::t::a::h -l server,client,mux::,server-name:,password:,method::,timeout::,dns-address::,help -- "$@"`
[ $? -ne 0 ] && show_help
eval set -- "${ARGS}"
while true
do
  case "$1" in
    -s|--server)
      RUNAS_SERVER=true
      ;;
    -c|--client)
      RUNAS_CLIENT=true
      ;;
    -x|--mux)
      MUX="$2"
      shift
      ;;
    -d|--server-name)
      SERVER_NAME="$2"
      shift
      ;;
    -p|--password)
      PASSWORD="$2"
      shift
      ;;
    -m|--method)
      METHOD="$2"
      shift
      ;;
    -t|--timeout)
      TIMEOUT="$2"
      shift
      ;;
    -a|--dns_address)
      DNS_ADDRS="$2"
      shift
      ;;
    -h|--help)
      show_help
      ;;
    --)
      shift
      break
      ;;
    esac

  shift
done

[ "$RUNAS_SERVER" = false -a "$RUNAS_CLIENT" = false ] && echo "必须指定启动方式。" && show_help
[ -z "$SERVER_NAME" ] && echo "初始化必须设置域名。" && show_help
[ -z "$PASSWORD" ] && echo "初始化必须设置密码。" && show_help

if [ "$RUNAS_SERVER" = true ]; then
  echo "{
    \"server\": \"127.0.0.1\",
    \"server_port\": 18650,
    \"password\": \"${PASSWORD}\",
    \"timeout\": ${TIMEOUT},
    \"method\": \"${METHOD}\",
    \"plugin\": \"v2ray-plugin\",
    \"plugin_opts\": \"server;path=/v2ray;loglevel=none\"
  }" > /etc/shadowsocks-libev/config.json

  sed -i 's@%SERVER_NAME%@'"${SERVER_NAME}"'@' /etc/nginx/conf.d/v2ray.conf
  nginx
  ss-server -c /etc/shadowsocks-libev/config.json -d ${DNS_ADDRS}
elif [ "$RUNAS_CLIENT" = true ]; then
  echo "{
    \"server\": \"$SERVER_NAME\",
    \"server_port\": 443,
    \"local_address\": \"0.0.0.0\",
    \"local_port\": 18650,
    \"password\": \"${PASSWORD}\",
    \"timeout\": \"${TIMEOUT}\",
    \"method\": \"${METHOD}\",
    \"plugin\": \"v2ray-plugin\",
    \"plugin_opts\": \"tls;host=$SERVER_NAME;path=/v2ray;mux=$MUX;loglevel=none\"
  }" > /etc/shadowsocks-libev/config.json

  ss-local -c /etc/shadowsocks-libev/config.json
fi
