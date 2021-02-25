#!/bin/bash

set -e

rm -rf new_node-exporter.json
cp node-exporter.json new_node-exporter.json
whoami=$(whoami)
REMOTE_NGROK_URL=$1
LOCAL_NGROK_URL=$(curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"https:..([^"]*).*/\1/p')
sed -i '' "s/LOCAL_NGROK_URL/$LOCAL_NGROK_URL/g" new_node-exporter.json
sed -i '' "s/whoami/$whoami/g" new_node-exporter.json
curl -X PUT --data-binary @new_node-exporter.json  https://${REMOTE_NGROK_URL}/v1/agent/service/register
cat new_node-exporter.json
rm -rf new_node-exporter.json
