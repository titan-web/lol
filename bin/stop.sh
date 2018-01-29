#!/usr/bin/env bash

root_path=/Users/titan/repository/lol

mkdir -p ${root_path}/logs

sudo nginx  -t -p ${root_path} -c ${root_path}/config/nginx.conf
sudo nginx  -s quit -p ${root_path} -c ${root_path}/config/nginx.conf

echo "nginx stop"
echo -e "===========================================\n\n"
tail -f ${root_path}/logs/error.log
