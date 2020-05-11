#!/bin/env sh

touch /aria2/data/aria2.session
darkhttpd /aria2/AriaNg --port 6801 &

PID_HTTPD=$!
PID_ARIA2=""

while true; do
  echo "Updating trackers list...."
  list=`wget -qO- https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt|awk NF|sed ":a;N;s/\n/,/g;ta"`
  sed -i "s@bt-tracker.*@bt-tracker=$list@g" /aria2/data/aria2.conf
  if [ -n "$list" ];then
    [ -n "$PID_ARIA2" ] && kill "$PID_ARIA2"
    aria2c --conf-path=/aria2/data/aria2.conf --stop-with-process="$PID_HTTPD" &
    PID_ARIA2=$!
    echo "New trackers list: "
    echo "$list"
    echo ""
  else
    echo "Failed to update trackers list."
  fi
  [ -n "$PID_ARIA2" ] && kill "$PID_ARIA2"
  aria2c --conf-path=/aria2/data/aria2.conf --stop-with-process="$PID_HTTPD" &
  PID_ARIA2=$!
  echo "aria2c is running...."
  sleep 12h
done
