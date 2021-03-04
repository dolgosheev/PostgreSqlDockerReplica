#!/bin/sh
contId=`docker ps -aqf "name=pgsql132-master"`
docker cp  $contId:/tmp/backup ./backup
echo "Success"
