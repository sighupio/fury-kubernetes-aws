#!/bin/bash

ALERT_NAME="cloud-init"
URL="$1"
INSTANCE="$(hostname -f)"

curl -XPOST -H "Content-Type: application/json" ${URL} -d "[{
\"labels\": {
    \"alertname\": \"${ALERT_NAME}\",
    \"severity\":\"warning\",
    \"instance\": \"${INSTANCE}\"
}, \"annotations\": {
    \"summary\": \"Cloud-init script fails. Take a look to the /cloud-init-report.sh.log file for more details\",
    \"instance\": \"${INSTANCE}\"
}}]"
