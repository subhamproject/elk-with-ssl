#!/bin/bash

#waiting for other elk server to be up
wait_for_elastic.sh "${ELASTIC_SERVERS}"

chmod -R 777 /etc/kibana/certs/ &&  chown -R kibana:kibana /etc/kibana/certs/


if [ -f /data/user_details.txt ];then
export USER_PASS=$(cat /data/user_details.txt |grep -w "kibana"|grep PASSWORD|cut -d'=' -f2|tr -d ' ')
export ES_PASSWORD=$(cat /data/user_details.txt |grep -w "elastic"|grep PASSWORD|cut -d'=' -f2|tr -d ' ')
#sed -i '/^elasticsearch.password/s;:.*$;: "${USER_PASS}";' /etc/kibana/kibana.yml
envsubst < /tmp/kibana.yml > /etc/kibana/kibana.yml
fi


[ $? -eq 0 ] && service kibana start
[ $? -eq 0 ] &&  echo "KIBANA CAN BE ACCESS WITH USERNAME:- elastic and PASSWORD:- ${ES_PASSWORD}"
tail -f /dev/null
