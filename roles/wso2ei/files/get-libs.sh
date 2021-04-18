#!/bin/bash
DOWNLOAD_URL=$(curl -X GET "http://10.15.75.132:8081/service/rest/v1/search?repository=libs-supeip" -H  "accept: application/json" | jq -r '.items [] | .assets [] | .downloadUrl')
LIB_DIR="/tmp/libs"

mkdir $LIB_DIR
for lib in $DOWNLOAD_URL
do
	wget $lib -P $LIB_DIR 
done

