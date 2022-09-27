#!/bin/bash

#To view all repositories;
curl -X GET "192.168.57.20:9200/_snapshot/_all?pretty"

#If you want to delete a snapshot repository;

curl -X DELETE "192.168.57.20:9200/_snapshot/es_backup/?pretty"


