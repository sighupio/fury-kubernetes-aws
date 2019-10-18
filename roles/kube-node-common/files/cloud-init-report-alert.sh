#!/bin/bash

# Notify function
# Sends notification to alertmanager
# $1: The alertmanager alerts url
# $2: Severity: warning,critical,error
# $3: Summary: Description about the error
notify()
{
    ALERT_NAME="cloud-init"
    URL="$1"
    SEVERITY="$2"
    SUMMARY="$3"
    INSTANCE="$(hostname -f)"

    curl -XPOST -H "Content-Type: application/json" ${URL} -d "[{
    \"labels\": {
        \"alertname\": \"${ALERT_NAME}\",
        \"severity\": \"${SEVERITY}\",
        \"instance\": \"${INSTANCE}\"
    }, \"annotations\": {
        \"summary\": \"${SUMMARY}\",
        \"instance\": \"${INSTANCE}\"
    }}]"
}
