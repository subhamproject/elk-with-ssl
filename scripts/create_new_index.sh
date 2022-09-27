#!/bin/bash

export INDEX_NAME=${1:-test}

docker exec elastic1 bash -c 'curl --cacert /etc/elasticsearch/certs/elk-ca.crt -XPUT -H "Content-Type: application/json" -s -u "elastic:$(cat /data/user_details.txt |grep -w "elastic"|grep PASSWORD|cut -d'=' -f2|tr -d " ")" https://elastic1:9200/subham?pretty'
