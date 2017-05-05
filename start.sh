#!/bin/bash

# Mount network shared drive
MOUNT_SOURCE="//192.168.1.13/Public"
MOUNT_DEST="/mnt/Public"
mkdir -p "$MOUNT_DEST"
mount -t cifs -o username=root,password=,guest,uid=1000,gid=1000,rw,file_mode=0777,dir_mode=0777,sfu "$MOUNT_SOURCE" "$MOUNT_DEST"

# Configure transmission
service transmission-daemon stop
: ${TRANSMISSION_CONFIG_DIR:="/data/transmission-daemon"}
TRANSMISSION_SETTINGS_PATH="$TRANSMISSION_CONFIG_DIR/settings.json"
TRANSMISSION_LOGS_PATH="$TRANSMISSION_CONFIG_DIR/logs.txt"

# Setup transmission
if [ -d "$TRANSMISSION_CONFIG_DIR" ]; then
    # Exists
    echo "Transmission already configured at \"$TRANSMISSION_CONFIG_DIR\"."
else
    # Does not exist
    echo "Transmission is not configured at \"$TRANSMISSION_CONFIG_DIR\"."
    mkdir -p "$TRANSMISSION_CONFIG_DIR"
    cp transmission_settings.json "$TRANSMISSION_SETTINGS_PATH"
fi

# Start transmission
transmission-daemon \
    --config-dir "$TRANSMISSION_CONFIG_DIR" \
    --logfile "$TRANSMISSION_LOGS_PATH" \
    --foreground
