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
docker-compose -f kibana_server.yaml -f elastic_cluster.yaml  down
