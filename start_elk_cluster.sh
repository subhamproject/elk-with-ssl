#!/bin/bash


function log() {
    echo "$1" >&2
}

function die() {
    log "$1"
    exit 1
}

function check_exist() {
    [ ! -z "$(command -v docker)" ] || die "THE 'docker' COMMAND IS MISSING - PLEASE INSTALL AND TRY AGAIN"
    [ ! -z "$(command -v docker-compose)" ] || die "THE 'docker-compose' COMMAND IS MISSING - PLEASE INSTALL AND TRY AGAIN"
}

check_exist

if [ ! -f "$(echo $script_path)/ca/elk-ca.crt" ];then
$(realpath $(dirname $0))/create_certs.sh
fi


echo "*** PLEASE WAIT THIS WILL TAKE SOMETIME TO START ALL CONTAINERS ***"
docker-compose -f elastic_cluster.yaml up -d
sleep 60
docker-compose -f elastic_cluster.yaml exec elastic1 bash -c "yes | ./usr/share/elasticsearch/bin/elasticsearch-setup-passwords auto > /data/user_details.txt"
[ $? -eq 0 ]  && docker-compose -f kibana_server.yaml -f elastic_cluster.yaml up -d kibana
