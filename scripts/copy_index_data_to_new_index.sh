#!/bin/bash
#https://www.hadoopinrealworld.com/how-to-copy-an-index-and-its-contents-to-a-new-index-in-elasticsearch/
export INDEX_NAME=${1:-test}

docker exec elastic1 bash -c 'curl --cacert /etc/elasticsearch/certs/elk-ca.crt  -X POST -s -u "elastic:$(cat /data/user_details.txt |grep -w "elastic"|grep PASSWORD|cut -d'=' -f2|tr -d " ")" https://elastic1:9200/_reindex  -H 'Content-Type: application/json' -d'
 {
   "source": {
     "index": "account"
   },
   "dest": {
     "index": "account_v2"
   }
 }'
 '
