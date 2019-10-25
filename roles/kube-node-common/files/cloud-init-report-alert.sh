#!/bin/bash

# Notify function
# Sends notification to alertmanager
# $1: The alertmanager alerts url
# $2: Severity: warning,critical,error
# $3: Summary: Description about the error
notify()
{
    ALERT_NAME="cloud-init"
    ALERT_MANAGER_HOSTNAME="$1"
    URL="http://${ALERT_MANAGER_HOSTNAME}/api/v2/alerts"
    SEVERITY="$2"
    SUMMARY="$3"
    INSTANCE="$(hostname -f)"

    curl -XPOST -m 5 -H "Content-Type: application/json" ${URL} -d "[{
    \"labels\": {
        \"alertname\": \"${ALERT_NAME}\",
        \"severity\": \"${SEVERITY}\",
        \"instance\": \"${INSTANCE}\"
    }, \"annotations\": {
        \"summary\": \"${SUMMARY}\",
        \"instance\": \"${INSTANCE}\"
    }}]"
}
