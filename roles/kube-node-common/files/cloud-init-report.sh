#!/bin/bash

# Block until cloud-init completes
cloud-init status --wait
RC=$?

echo "Cloud-init exit status: $RC" > /cloud-init-report.sh.log

if [ $RC -ne 0 ]
then
    echo 'Cloud-init failed' >> /cloud-init-report.sh.log
    echo 'Cloud-init status:' >> /cloud-init-report.sh.log
    cat /run/cloud-init/status.json >> /cloud-init-report.sh.log
    echo 'Cloud-init result:' >> /cloud-init-report.sh.log
    cat /run/cloud-init/result.json >> /cloud-init-report.sh.log
    /cloud-init-report-alert.sh "$1"
    exit 1
else
    echo 'Cloud-init succeeded at ' `date -R`  >> /cloud-init-report.sh.log
fi
