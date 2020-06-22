#!/bin/env sh

show_help() {
  echo ""
  echo "Usage:"
  echo "  docker run [docker_opts] liyuqihxc/aria2[:tag] [options]"
  echo ""
  echo "Options:"
  echo "  -s, --rpc-secret       RPC授权令牌"
  echo "  -a, --address          Upnp映射地址"
  echo "  -h, --help             显示帮助信息并退出"
  echo ""
  echo "Example:"
  echo "    docker run [docker_opts] liyuqihxc/aria2[:tag] -s <super secret token>"
  echo "    docker run [docker_opts] --network host liyuqihxc/aria2[:tag] -s <super secret token> -a <ip address>"
  echo ""
  exit 0
}

RPC_SECRET=""
UPNP_ADDRESS=""
UPNP_PORTS=""

ARGS=`getopt -a -o s:a:p:h -l rpc-secret:,address:,port:,help -- "$@"`
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

if [[ -n $UPNP_ADDRESS && -n $UPNP_PORTS ]];then
  for i in $(seq $(echo $UPNP_PORTS | sed -e "s/-/ /"))
  do
    echo "Mapping endpoint: $UPNP_ADDRESS:$i"
    upnpc -a $UPNP_ADDRESS $i $i TCP;
    upnpc -a $UPNP_ADDRESS $i $i UDP;
  done
fi

touch /aria2/config/aria2.session
darkhttpd /aria2/AriaNg --port %HTTP_LISTEN_PORT% &
cp /aria2/aria2.conf /aria2/config/aria2.conf

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
