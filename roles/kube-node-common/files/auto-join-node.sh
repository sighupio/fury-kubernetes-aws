#!/bin/bash

source /cloud-init-report-alert.sh


# Join function
# Downloads the kubeadm token and execute it
# $1: bucket+key where token is located
join()
{
    JOIN_TOKEN_URL=$1
    aws s3 cp s3://${JOIN_TOKEN_URL} /token.sh
    systemctl restart kubelet
    cat /token.sh | echo "$(cat -) --node-name=$(hostname -f)" | bash
}

JOIN_TOKEN_URL=$1
ALERTMANAGER_URL=$2

RETRIES=3
RETRY_SECONDS=10

n=0
fail_join=1
me=`basename "$0"`

until [ $n -ge $RETRIES ]
do
   join $JOIN_TOKEN_URL && fail_join=0 && break
   n=$[$n+1]
   notify $ALERTMANAGER_URL "warning" "Cloud-init script is failing. /$me causes this warning"
   sleep $RETRY_SECONDS
done
exit $fail_join