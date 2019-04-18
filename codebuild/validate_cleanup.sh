#!/usr/bin/bash

[ $# == 1 ] || exit 1

ami-get-snapshot() {
    aws ec2 describe-images --owners self --image-id $1 --output json | jq -r '.Images[].BlockDeviceMappings[] | select(.Ebs != null ) | .Ebs.SnapshotId'
}


ami-delete() {
    snaps=$(ami-get-snapshot $1)
    aws ec2 deregister-image --image-id $1
    for id in $snaps; do
	if [ -n $id ]; then
	    aws ec2 delete-snapshot --snapshot-id $id
        fi
    done
}

ami-delete $1



