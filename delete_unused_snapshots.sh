#! /bin/bash

I=0
DRYRUN=false

# Check if the script is run with dry run argument
while getopts 'd' opt; do
    case "$opt" in
        d) DRYRUN=true ;;
        *) echo 'Invalid argument' >&2
           exit 1
    esac
done

# Get AWS Account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGEX='^[0-9]+$'
if ! [[ $AWS_ACCOUNT_ID =~ $REGEX ]] ; then
   echo 'Error retrieving AWS Account ID' >&2
   exit 1
fi

# Get the list of snapshots not linked to any available or pending AMI
SNAPSHOT_IDS=$(comm -23 <(aws ec2 describe-snapshots --owner-ids $AWS_ACCOUNT_ID --query 'Snapshots[*].SnapshotId' --output text | tr '\t' '\n' | sort) <(aws ec2 describe-images --filters Name=state,Values=available,pending --owners $AWS_ACCOUNT_ID --query "Images[*].BlockDeviceMappings[*].Ebs.SnapshotId" --output text | tr '\t' '\n' | sort | uniq))

if "$DRYRUN"; then
    # Echo the list of snapshots not linked to any available or pending AMI
    echo 'Entering dry run mode'
    for snapshotId in $SNAPSHOT_IDS; do
        I=$((I+1))
        echo "$I - Found snapshotId $snapshotId"
    done
else
    echo 'Entering delete mode'
    # Delete the snapshots
    for snapshotId in $SNAPSHOT_IDS; do
        I=$((I+1))
        echo "$I - Deleting snapshotId $snapshotId"
        aws ec2 delete-snapshot --snapshot-id $snapshotId
    done
fi
echo "Done, found $I snapshot(s)"

exit 0
