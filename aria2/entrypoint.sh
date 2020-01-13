#!/bin/env sh

touch /aria2/aria2.session
darkhttpd /aria2/AriaNg --port 6801 &
aria2c --conf-path=/aria2/aria2.conf
