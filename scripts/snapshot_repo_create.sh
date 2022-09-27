#!/bin/bash
#https://kifarunix.com/backup-and-restore-elasticsearch-index-data/


# where es_backup is a repository name

export INDEX_NAME=${1:-test}

docker exec elastic1 bash -c 'curl --cacert /etc/elasticsearch/certs/elk-ca.crt -s -u "elastic:$(cat /data/user_details.txt |grep -w "elastic"|grep PASSWORD|cut -d'=' -f2|tr -d " ")"  -XGET https://elastic1:9200/_snapshot/es_backup?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/mnt/es_backup"
  }
}'
'
