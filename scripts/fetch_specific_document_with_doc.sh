#!/bin/bash
#https://www.hadoopinrealworld.com/how-to-copy-an-index-and-its-contents-to-a-new-index-in-elasticsearch/

docker  exec  elastic1 bash -c 'curl --cacert /etc/elasticsearch/certs/elk-ca.crt -s -u "elastic:$(cat /data/user_details.txt |grep -w "elastic"|grep PASSWORD|cut -d'=' -f2|tr -d " ")" https://elastic1:9200/my_index-2022.09.26/_doc/2840?pretty'

