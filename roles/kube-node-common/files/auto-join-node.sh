#!/bin/bash

source /cloud-init-report-alert.sh

MAX_RETRIES=100
MAX_TIMEOUT=1800


function get_random_number() {
    local start=$1
    local end=$2
    local range_len=$(($end - $start))

    echo $(( ($RANDOM % $range_len) + $start ))
}

function to_power() {
    local base=$1
    local power=$2
    echo "$base^$power" | bc
}

function run_with_exponential_backoff() {
    local cmd=$*
    local timeout=1
    local failcount=0
    local secret=
    local return_code=1

    while :
    do
	set +e
        secret=`$cmd`
        return_code=$?
	set -e
        if [[ $return_code -eq 0 ]]
        then
            break
	fi

    #this will add a non linear exponential backoff
    timeout=$(( `get_random_number 0 1` + `to_power $failcount 2` ))
	failcount=$(( $failcount + 1 ))

        if [[ $failcount -ge $MAX_RETRIES ]]
        then
            >&2 echo Maximum number of retries of $MAX_RETRIES reached...
            exit 2
	fi

        if [[ $timeout -gt $MAX_TIMEOUT ]]
        then
            timeout=$MAX_TIMEOUT
	fi

        >&2 echo Will retry in ${timeout}s...
        sleep $timeout
    done

    echo $secret
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

n=0
fail_join=1
me=`basename "$0"`

MAX_ATTEMPTS=200

SLEEP_MILLISECS=1000

join_command=$(join $JOIN_TOKEN_URL && fail_join=0 && break)

run_with_exponential_backoff $join_command || notify $ALERT_MANAGER_HOSTNAME "warning" "Cloud-init script is failing. /$me causes this warning"
echo "fail all attempts to join cluster"; exit $fail_join
