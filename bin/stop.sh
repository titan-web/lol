#!/usr/bin/env bash

root_path=/Users/titan/repository/lol

sudo nginx  -t -c ${root_path}/config/nginx.conf
sudo nginx  -s quit -c ${root_path}/config/nginx.conf

echo "nginx stop"
echo -e "===========================================\n\n"
tail -f /usr/local/nginx/logs/error.log
