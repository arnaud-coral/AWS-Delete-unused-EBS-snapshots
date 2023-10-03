#!/bin/bash

# Initialize default value for dry run mode
DRYRUN=false

# Parse command line arguments
while getopts 'd' opt; do
    case "$opt" in
        d)
            # Set dry run mode if -d option is passed
            DRYRUN=true
            ;;
        *)
            # Inform user of invalid argument and exit
            echo 'Invalid argument' >&2
            exit 1
            ;;
    esac
done

# Fetch AWS Account ID and inform the user of the action
echo "Fetching AWS Account ID..."
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Define a regular expression to validate the AWS Account ID format
REGEX='^[0-9]+$'

# Check if AWS_ACCOUNT_ID matches the expected pattern
if ! [[ $AWS_ACCOUNT_ID =~ $REGEX ]] ; then
   echo 'Error retrieving AWS Account ID' >&2
   exit 1
fi

# Inform user that we're fetching the list of unlinked snapshots
echo "Fetching unlinked snapshots..."

# Fetch list of snapshots owned by the current AWS account
OWNED_SNAPSHOTS=$(aws ec2 describe-snapshots --owner-ids $AWS_ACCOUNT_ID --query 'Snapshots[*].SnapshotId' --output text | tr '\t' '\n' | sort)

# Fetch list of snapshots linked to any available or pending AMI
AMIs_SNAPSHOTS=$(aws ec2 describe-images --filters Name=state,Values=available,pending --owners $AWS_ACCOUNT_ID --query "Images[*].BlockDeviceMappings[*].Ebs.SnapshotId" --output text | tr '\t' '\n' | sort | uniq)

# Extract snapshots that are not linked to any available or pending AMI
UNLINKED_SNAPSHOTS=$(comm -23 <(echo "$OWNED_SNAPSHOTS") <(echo "$AMIs_SNAPSHOTS"))

# Initialize a counter for the number of processed snapshots
COUNT=0

# Check dry run mode
if "$DRYRUN"; then
    echo 'Entering dry run mode...'
    # Loop through each unlinked snapshot and display it
    for snapshotId in $UNLINKED_SNAPSHOTS; do
        COUNT=$((COUNT+1))
        echo "$COUNT - Found snapshotId $snapshotId"
    done
else
    echo 'Entering delete mode...'
    # Loop through each unlinked snapshot and delete it
    for snapshotId in $UNLINKED_SNAPSHOTS; do
        COUNT=$((COUNT+1))
        echo "$COUNT - Deleting snapshotId $snapshotId"
        aws ec2 delete-snapshot --snapshot-id $snapshotId
    done
fi

# Display the total number of processed snapshots
echo "Done, found $COUNT snapshot(s)"

# Exit the script with a success status
exit 0
