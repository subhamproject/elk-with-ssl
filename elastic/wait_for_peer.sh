#!/bin/bash

wait_for_servers () {
HOST=$1
PORT=$2
echo "Waiting for $HOST to launch on port $PORT..."
while ! timeout 2 bash -c "echo > /dev/tcp/$HOST/$PORT" > /dev/null 2>&1 ; do   
  sleep 2
done
echo "$HOST is up on port $PORT"
}

SERVER=$1
[[ -z $SERVER ]] && { echo "Please provide elastic server details" ; exit 1 ; }

if [[ -n $SERVER ]];then
IFS=','; for name in $SERVER; do
    IFS=':' read -a NAME <<< "$name"
    wait_for_servers ${NAME[0]} ${NAME[1]}
   done
fi
