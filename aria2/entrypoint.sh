#!/bin/env sh

HTTP_LISTEN_PORT=%HTTP_LISTEN_PORT%
RPC_LISTEN_PORT=%RPC_LISTEN_PORT%
RPC_SECRET=""
UPNP_ADDRESS=""
UPNP_PORTS="%UPNP_PORTS%"

show_help() {
  echo ""
  echo "Usage:"
  echo "  docker run [docker_opts] liyuqihxc/aria2[:tag] [options]"
  echo ""
  echo "Options:"
  echo "  -s, --rpc-secret       RPC授权令牌"
  echo "  -a, --address          Upnp映射地址"
  echo "  -b, --bt-port          Upnp映射端口"
  echo "      对应aria2 listen-port 与 dht-listen-port，默认$UPNP_PORTS"
  echo "  -r, --rpc-port         RPC监听端口"
  echo "      对应aria2 rpc-listen-port，默认$RPC_LISTEN_PORT"
  echo "  -d, --http-port        HTTP服务器端口"
  echo "      AriaNg静态文件服务器端口，默认$HTTP_LISTEN_PORT"
  echo "  -h, --help             显示帮助信息并退出"
  echo ""
  echo "Example:"
  echo "    docker run [docker_opts] liyuqihxc/aria2[:tag] -s <super secret token>"
  echo "    docker run [docker_opts] --network host -expose 16881-16900 liyuqihxc/aria2[:tag] -s <super secret token> -a <ip address> -b 16881-16900"
  echo ""
  exit 0
}

ARGS=`getopt -a -o s:a:b:r:d:h -l rpc-secret:,address:,bt-port:,rpc-port:,http-port:,help -- "$@"`
[ $? -ne 0 ] && show_help
eval set -- "${ARGS}"
while true
do
  case "$1" in
    -s|--rpc-secret)
      RPC_SECRET="$2"
      shift
      ;;
    -a|--address)
      UPNP_ADDRESS="$2"
      shift
      ;;
    -b|--bt-port)
      UPNP_PORTS="$2"
      shift
      ;;
    -r|--rpc-port)
      RPC_LISTEN_PORT="$2"
      shift
      ;;
    -d|--http-port)
      HTTP_LISTEN_PORT="$2"
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

if [ -n "$RPC_SECRET" ];then
  sed -i "s/^rpc-secret.*$/rpc-secret=$RPC_SECRET/g" /aria2/aria2.conf
else
  sed -i "s/^rpc-secret.*$/#rpc-secret=/g" /aria2/aria2.conf
fi

sed -i "s/^rpc-listen-port.*$/rpc-listen-port=$RPC_LISTEN_PORT/g" /aria2/aria2.conf
sed -i "s/^listen-port.*$/listen-port=$UPNP_PORTS/g" /aria2/aria2.conf
sed -i "s/^dht-listen-port.*$/dht-listen-port=$UPNP_PORTS/g" /aria2/aria2.conf

if [[ -n $UPNP_ADDRESS && -n $UPNP_PORTS ]];then
  upnpc -l > upnp.log
  for i in $(seq $(echo $UPNP_PORTS | sed -e "s/-/ /"))
  do
    echo "Mapping endpoint: $UPNP_ADDRESS:$i"
    cat upnp.log | grep "TCP.*$UPNP_ADDRESS:$i" >/dev/null 2>&1
    [ $? -ne 0 ] && upnpc -a $UPNP_ADDRESS $i $i TCP >/dev/null 2>&1
    cat upnp.log | grep "UDP.*$UPNP_ADDRESS:$i" >/dev/null 2>&1
    [ $? -ne 0 ] && upnpc -a $UPNP_ADDRESS $i $i UDP >/dev/null 2>&1
  done
fi

touch /aria2/config/aria2.session
darkhttpd /aria2/AriaNg --port $HTTP_LISTEN_PORT &
[ -e "/aria2/config/aria2.conf" ] && cp /aria2/aria2.conf /aria2/config/aria2.conf

PID_HTTPD=$!
PID_ARIA2=""

while true; do
  echo "Updating trackers list...."
  list=`wget -qO- https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt | awk NF | sed ":a;N;s/\n/,/g;ta"`
  sed -i "s/^bt-tracker.*$/bt-tracker=$list/g" /aria2/config/aria2.conf
  if [ -n "$list" ];then
    echo "New trackers list: "
    echo "$list"
    echo ""
  else
    echo "Failed to update trackers list."
  fi
  [ -n "$PID_ARIA2" ] && kill "$PID_ARIA2"
  PID_ARIA2=""
  aria2c --conf-path=/aria2/config/aria2.conf --stop-with-process="$PID_HTTPD" &
  PID_ARIA2=$!
  echo "aria2c is running...."
  sleep 12h
done
