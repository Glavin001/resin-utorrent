#!/bin/bash
set -e

echo "Starting Torrent Client"

#===== CUSTOMIZE =====
# Mount network shared drive
MOUNT_FOLDER="Public"
MOUNT_SOURCE="//192.168.1.13/$MOUNT_FOLDER"
MOUNT_DEST="/data/mount/$MOUNT_FOLDER"
mkdir -p "$MOUNT_DEST"
echo "Mounting $MOUNT_SOURCE to $MOUNT_DEST"
mount -t cifs -o username=root,password=,guest,uid=1000,gid=1000,rw,file_mode=0777,dir_mode=0777,sfu "$MOUNT_SOURCE" "$MOUNT_DEST"
if [ $? -eq 1 ]; then
    echo "Mounting failed!"
fi
#===== CUSTOMIZE =====

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
    echo "Created transmission configuration at $TRANSMISSION_SETTINGS_PATH"
fi

# Start transmission
transmission-daemon \
    --config-dir "$TRANSMISSION_CONFIG_DIR" \
    --logfile "$TRANSMISSION_LOGS_PATH" \
    --foreground

echo "Transmission-daemon has stopped"
