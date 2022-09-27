#!/bin/bash

if [ "$1" == "" ] || [ "$2" == "" ]; then
  echo "Usage: ./reindex.sh [REMOTE_HOST:REMOTE_PORT] [INDEX_PATTERN] [LOCAL_HOST:LOCAL_PORT]"
  exit 1
fi

REMOTE_HOST=$1
PATTERN=$2
if [ "$3" == "" ]; then
  LOCAL_HOST="localhost:9200"
else
  LOCAL_HOST=$3
fi

echo "---------------------------- NOTICE ----------------------------------"
echo "You must ensur you have the following setting in your local ES host's:"
echo "elasticsearch.yml config (the one re-indexing to):"
echo "    reindex.remote.whitelist: $REMOTE_HOST"
echo "Also, if an index template is necessary for this data, you must create"
echo "locally before you start the re-indexing process"
echo "----------------------------------------------------------------------"
sleep 3

INDICES=$(curl --silent "$REMOTE_HOST/_cat/indices/$PATTERN?h=index")
TOTAL_INCOMPLETE_INDICES=0
TOTAL_INDICES=0
TOTAL_DURATION=0
INCOMPLETE_INDICES=()

for INDEX in $INDICES; do

  TOTAL_DOCS_REMOTE=$(curl --silent "http://$REMOTE_HOST/_cat/indices/$INDEX?h=docs.count")
  echo "Attempting to re-indexing $INDEX ($TOTAL_DOCS_REMOTE docs total) from remote ES server..."
  SECONDS=0
  curl -XPOST "http://$LOCAL_HOST/_reindex?wait_for_completion=true&pretty=true" -d "{
    \"conflicts\": \"proceed\",
    \"source\": {
      \"remote\": {
        \"host\": \"http://$REMOTE_HOST\"
      },
      \"index\": \"${INDEX}\"
    },
    \"dest\": {
      \"index\": \"${INDEX}\"
    }
  }"

  duration=$SECONDS

  LOCAL_INDEX_EXISTS=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "http://$LOCAL_HOST/$INDEX")
  if [ "$LOCAL_INDEX_EXISTS" == "200" ]; then
    TOTAL_DOCS_REINDEXED=$(curl --silent "http://$LOCAL_HOST/_cat/indices/$INDEX?h=docs.count")
  else
    TOTAL_DOCS_REINDEXED=0
  fi

  echo "    Re-indexing results:"
  echo "     -> Time taken: $(($duration / 60)) minutes and $(($duration % 60)) seconds"
  echo "     -> Docs indexed: $TOTAL_DOCS_REINDEXED out of $TOTAL_DOCS_REMOTE"
  echo ""

  TOTAL_DURATION=$(($TOTAL_DURATION+$duration))

  if [ "$TOTAL_DOCS_REMOTE" -ne "$TOTAL_DOCS_REINDEXED" ]; then
    TOTAL_INCOMPLETE_INDICES=$(($TOTAL_INCOMPLETE_INDICES+1))
    INCOMPLETE_INDICES+=($INDEX)
  fi

  TOTAL_INDICES=$((TOTAL_INDICES+1))

done

echo "---------------------- STATS --------------------------"
echo "Total Duration of Re-Indexing Process: $((TOTAL_DURATION / 60))m $((TOTAL_DURATION % 60))"
echo "Total Indices: $TOTAL_INDICES"
echo "Total Incomplete Re-Indexed Indices: $TOTAL_INCOMPLETE_INDICES"
if [ "$TOTAL_INCOMPLETE_INDICES" -ne "0" ]; then
  printf '%s\n' "${INCOMPLETE_INDICES[@]}"
fi
echo "-------------------------------------------------------"
echo ""
