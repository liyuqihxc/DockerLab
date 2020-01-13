#!/bin/env sh

touch /aria2/aria2.session
darkhttpd /aria2/AriaNg --port 6801 &

while true; do
  list=`wget -qO- https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt|awk NF|sed ":a;N;s/\n/,/g;ta"`
  sed -i "s@bt-tracker.*@bt-tracker=$list@g" /aria2/aria2.conf
  [[ $(jobs | wc -l) == "2" ]] && kill %2
  aria2c --conf-path=/aria2/aria2.conf &
  sleep 2h
done
