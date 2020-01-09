#!/bin/bash

source /cloud-init-report-alert.sh

function err_retry() {
  local exit_code=$1
  local attempts=$2
  local sleep_millis=$3
  shift 3
  for attempt in `seq 1 $attempts`; do
    if [[ $attempt -gt 1 ]]; then
      echo "Attempt $attempt of $attempts"
    fi
    # This weird construction lets us capture return codes under -o errexit
    "$@" && local rc=$? || local rc=$?
    if [[ ! $rc -eq $exit_code ]]; then
      return $rc
    fi
    if [[ $attempt -eq $attempts ]]; then
      return $rc
    fi
    local sleep_ms="$(($attempt * $attempt * $sleep_millis))"
    sleep "${sleep_ms:0:-3}.${sleep_ms: -3}"
  done
}
# Join function
# Downloads the kubeadm token and execute it
# $1: bucket+key where token is located
join()
{
    JOIN_TOKEN_URL=$1
    aws s3 cp ${JOIN_TOKEN_URL} /token.sh
    systemctl restart kubelet
    cat /token.sh | echo "$(cat -) --node-name=$(hostname -f)" | bash
}
S3_BUCKET_NAME=$1
JOIN_TOKEN_URL="s3://${S3_BUCKET_NAME}/join/join.sh"
ALERT_MANAGER_HOSTNAME=$2

RETRIES=300
RETRY_SECONDS=10

n=0
fail_join=1
me=`basename "$0"`

MAX_ATTEMPTS=50

SLEEP_MILLISECS=1000

join_command=$(join $JOIN_TOKEN_URL && fail_join=0 && break)

err_retry 2 $MAX_ATTEMPTS $SLEEP_MILLISECS $join_command || notify $ALERT_MANAGER_HOSTNAME "warning" "Cloud-init script is failing. /$me causes this warning"
echo "fail all attempts to join cluster"; exit $fail_join
