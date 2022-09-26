#!/bin/bash

sudo service ssh start

#waiting for other elk server to be up
wait_for_peer.sh "${PEER_SERVERS}"

cp /elastic${SERVER_ID}/elasticsearch.yml /tmp/elasticsearch.yml && sudo chmod 777 /tmp/elasticsearch.yml && sudo chown elasticsearch:elasticsearch /tmp/elasticsearch.yml

envsubst < /tmp/elasticsearch.yml > /etc/elasticsearch/elasticsearch.yml

sudo chmod -R 777 /etc/elasticsearch/certs/ && sudo chown -R elasticsearch:elasticsearch /etc/elasticsearch/certs/

sudo chmod -R 777 /data 

case ${HOSTNAME} in
elastic1)
sudo sed -i "/^node.data/s;:.*$;: false;" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "/^node.ingest/s;:.*$;: false;" /etc/elasticsearch/elasticsearch.yml
;;
esac

exec /usr/share/elasticsearch/bin/elasticsearch
