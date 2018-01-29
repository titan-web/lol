#!/usr/bin/env bash

root_path=/Users/titan/repository/lol

mkdir -p ${root_path}/logs

ps -fe|grep nginx |grep -v grep
if [ $? -ne 0 ]
then
  sudo nginx  -p ${root_path} -t -c ${root_path}/config/nginx.conf
  sudo nginx  -p ${root_path} -c ${root_path}/config/nginx.conf
  echo "nginx start"
else
  sudo nginx  -p ${root_path} -t -c ${root_path}/config/nginx.conf
  sudo nginx  -p ${root_path} -s reload -c ${root_path}/config/nginx.conf
  echo "nginx reload"
fi
echo -e "===========================================\n\n"
tail -f ${root_path}/logs/error.log
