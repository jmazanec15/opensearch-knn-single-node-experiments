#!/bin/bash

set -mxe

echo "Starting Opensearch"
PROFILES_PATH="/share-data/profiles"
mkdir -p -m 777 ${PROFILES_PATH}
./opensearch-docker-entrypoint.sh opensearch &
ENTRY_PID=$!
echo "Entry: ${ENTRY_PID}"
sleep 5
OS_PID=`ps aux | grep "[o]rg.opensearch.bootstrap.OpenSearch" | tr -s ' ' | cut -d ' ' -f2`
echo "OS: ${OS_PID}"
bash /profile-poller.sh ${OS_PID} &
bash /process-stats-collector.sh ${OS_PID} ${RUN_ID} &
bash /graceful-shutdown-poller.sh ${OS_PID} &

# Foreground original process
fg %1
