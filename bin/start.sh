#!/usr/bin/env bash

root_path=/Users/titan/repository/lol

ps -fe|grep nginx |grep -v grep
if [ $? -ne 0 ]
then
  sudo nginx  -t -c ${root_path}/config/nginx.conf
  sudo nginx  -c ${root_path}/config/nginx.conf
  echo "nginx start"
else
  sudo nginx  -t -c ${root_path}/config/nginx.conf
  sudo nginx  -s reload -c ${root_path}/config/nginx.conf
  echo "nginx reload"
fi
echo -e "===========================================\n\n"
tail -f /usr/local/nginx/logs/error.log
