#!/bin/bash

# Directory to store virtual disks
OUTPUT_DIR="$HOME/VirtualDisks"
DISK_NAME_PREFIX="disk"
DISK_COUNT=3  # Number of disks to create
DISK_SIZE=40960  # Size in MB (40 GB)

# Ensure VBoxManage is installed and accessible
if ! command -v VBoxManage &>/dev/null; then
    echo "VBoxManage is not installed or not in your PATH. Install VirtualBox and try again."
    exit 1
fi

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Create the virtual disks
for i in $(seq 1 $DISK_COUNT); do
    DISK_PATH="$OUTPUT_DIR/${DISK_NAME_PREFIX}_$i.vdi"
    echo "Creating virtual disk: $DISK_PATH (40 GB)"
    
    VBoxManage createhd --filename "$DISK_PATH" --size $DISK_SIZE --format VDI
    
    if [[ $? -eq 0 ]]; then
        echo "Successfully created $DISK_PATH"
    else
        echo "Failed to create $DISK_PATH"
    fi
done

echo "Finished creating $DISK_COUNT disks in $OUTPUT_DIR."

