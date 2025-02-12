#!/bin/bash

# Get a list of all registered hard disk UUIDs
DISK_UUIDS=$(VBoxManage list hdds | grep "^UUID:" | awk '{print $2}')

# Loop through each UUID and unregister/delete the disk
for UUID in $DISK_UUIDS; do
    echo "Unregistering and deleting disk with UUID: $UUID"
    VBoxManage closemedium disk "$UUID" --delete
    if [[ $? -eq 0 ]]; then
        echo "Successfully deleted disk with UUID: $UUID"
    else
        echo "Failed to delete disk with UUID: $UUID"
    fi
done

echo "All registered hard disks have been deleted."

