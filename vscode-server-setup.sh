#!/bin/bash

# Set variables
VSCODE_VERSION="1.93.1"
COMMIT_ID="38c31bc77e0dd6ae88a4e9cc93428cc27a56ba40"
ARCH="arm64"
SERVER_DIR="/home/sammy/.vscode-server"
DOWNLOAD_URL="https://update.code.visualstudio.com/commit:${COMMIT_ID}/server-linux-${ARCH}/stable"

# Create necessary directories
mkdir -p "${SERVER_DIR}/cli/servers/Stable-${COMMIT_ID}/server"
mkdir -p "${SERVER_DIR}/data"
mkdir -p "${SERVER_DIR}/extensions"

# Create .writeMachineSettingsMarker
# touch "${SERVER_DIR}/data/Machine/.writeMachineSettingsMarker"

# Create empty settings.json file
# echo "{}" > "${SERVER_DIR}/data/Machine/settings.json"

# Download VS Code server (only if network is available)
if wget -q --spider http://google.com; then
    echo "Downloading Visual Studio Code server..."
    wget -O "${SERVER_DIR}/vscode-server-linux-${ARCH}.tar.gz" "${DOWNLOAD_URL}"

    # Extract the server
    echo "Extracting server..."
    tar -xzf "${SERVER_DIR}/vscode-server-linux-${ARCH}.tar.gz" -C "${SERVER_DIR}/cli/servers/Stable-${COMMIT_ID}/server" --strip-components=1

    # Clean up
    rm "${SERVER_DIR}/vscode-server-linux-${ARCH}.tar.gz"
else
    echo "Network not available. Creating placeholder files..."
    mkdir -p "${SERVER_DIR}/bin/${COMMIT_ID}/bin"
    touch "${SERVER_DIR}/bin/${COMMIT_ID}/bin/code-server"
    chmod +x "${SERVER_DIR}/bin/${COMMIT_ID}/bin/code-server"
fi

cp -pr ${SERVER_DIR}/cli/servers/Stable-${COMMIT_ID}/server/extensions ${SERVER_DIR}/extensions

# Ensure correct permissions
chown -R sammy:root "${SERVER_DIR}"
chmod -R 755 "${SERVER_DIR}"

# Set up the server binary
# ln -s "${SERVER_DIR}/bin/${COMMIT_ID}/bin/code-server" "/usr/bin/code-server"

echo "VS Code Server setup complete."