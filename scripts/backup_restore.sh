#!/bin/bash

#This script automates the creation of elasticsearch index backup(.kibana)
mkdir -p /etc/elasticsearch/backup
chown -R elasticsearch /etc/elasticsearch/backup
sudo apt-get install curl

#add the required path.repo to elasticsearch yaml file
cat >> /etc/elasticsearch/elasticsearch.yml << EOF
path.repo: ["/etc/elasticsearch/backup"]
EOF
URL_REQ="http://localhost:9200/_snapshot/my_backup"
#inform elasticsearch of the backup repository
curl -m 30 -XPUT $URL_REQ -H'Content-Type: application/json' -d '{
 "type": "fs",
 "settings": {
 "location": “/etc/elasticsearch/backup”,
 "compress": true
 }
}'
backup_index=".kibana"
TIMESTAMP=`date +%Y%m%d`


#specify the index to backup
#include_global_state: to prevent the cluster global state to be stored as part of the snapshot
curl -XPUT "$URL_REQ/$TIMESTAMP?wait_for_completion=true" -H 'Content-Type: application/json' -d '{
"indices": "$backup_index",
 "ignore_unavailable": true,
 "include_global_state": false
}'


# The amount of snapshots we want to keep.
LIMIT=30
# Get a list of snapshots we want to delete omitting the most recent index
SNAPSHOTS=`curl -m 30 -s -XGET "$URL_REQ/_all" -H 'Content-Type: application/json' \
 | jq ".snapshots[:-${LIMIT}][].snapshot"`


# Loop over the results and delete old snapshots
for SNAPSHOT in $SNAPSHOTS
do
 echo "Deleting snapshot: $SNAPSHOT"
 curl -m 30 -s -XDELETE '$URL_REQ/$SNAPSHOT?pretty'
done
echo "Done!"
