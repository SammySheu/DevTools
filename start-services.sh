#!/bin/bash

# Set variables
VSCODE_VERSION="1.93.1"
COMMIT_ID="38c31bc77e0dd6ae88a4e9cc93428cc27a56ba40"
ARCH="arm64"
SERVER_DIR="/home/sammy/.vscode-server"
BIN_DIR="${SERVER_DIR}/cli/servers/Stable-${COMMIT_ID}/server/bin"

# Start SSH service
/usr/sbin/sshd &

# Start VSCode Server
# Basic command to start VS Code Server
# ${SERVER_DIR}/cli/servers/Stable-38c31bc77e0dd6ae88a4e9cc93428cc27a56ba40/server/node \
# ${SERVER_DIR}/cli/servers/Stable-38c31bc77e0dd6ae88a4e9cc93428cc27a56ba40/server/out/server-main.js \
# --connection-token=remotessh \
# --accept-server-license-terms \
# --start-server \
# --enable-remote-auto-shutdown \
# --socket-path=/tmp/code-helloworld
# --host=0.0.0.0               # Specify the host to bind to
# --port=8080                    # Specify a port to listen on
# --without-connection-token     # Disable the connection token requirement (less secure)
# --server-data-dir=${SERVER_DIR}/data # Specify a custom data directory
# --telemetry-level=off          # Disable telemetry
# --log debug                    # Enable debug logging


# Keep the container running
tail -f /dev/null