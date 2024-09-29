#!/bin/bash

# Set variables
VSCODE_VERSION="1.93.1"
COMMIT_ID="38c31bc77e0dd6ae88a4e9cc93428cc27a56ba40"
ARCH="arm64"
SERVER_DIR="/root/.vscode-server"
DOWNLOAD_URL="https://update.code.visualstudio.com/commit:${COMMIT_ID}/server-linux-${ARCH}/stable"

# Create necessary directories
mkdir -p "${SERVER_DIR}/bin/${COMMIT_ID}"
mkdir -p "${SERVER_DIR}/data/Machine"
mkdir -p "${SERVER_DIR}/extensions"

# Create .writeMachineSettingsMarker
touch "${SERVER_DIR}/data/Machine/.writeMachineSettingsMarker"

# Create empty settings.json file
echo "{}" > "${SERVER_DIR}/data/Machine/settings.json"

# Download VS Code server (only if network is available)
if wget -q --spider http://google.com; then
    echo "Downloading Visual Studio Code server..."
    wget -O "${SERVER_DIR}/vscode-server-linux-${ARCH}.tar.gz" "${DOWNLOAD_URL}"

    # Extract the server
    echo "Extracting server..."
    tar -xzf "${SERVER_DIR}/vscode-server-linux-${ARCH}.tar.gz" -C "${SERVER_DIR}/bin/${COMMIT_ID}" --strip-components=1

    # Clean up
    rm "${SERVER_DIR}/vscode-server-linux-${ARCH}.tar.gz"
else
    echo "Network not available. Creating placeholder files..."
    mkdir -p "${SERVER_DIR}/bin/${COMMIT_ID}/bin"
    touch "${SERVER_DIR}/bin/${COMMIT_ID}/bin/code-server"
    chmod +x "${SERVER_DIR}/bin/${COMMIT_ID}/bin/code-server"
fi

# Create a version file
echo "${VSCODE_VERSION}" > "${SERVER_DIR}/bin/${COMMIT_ID}/version"

# Create product.json file
cat << EOF > "${SERVER_DIR}/bin/${COMMIT_ID}/product.json"
{
    "commit": "${COMMIT_ID}",
    "quality": "stable",
    "dataFolderName": ".vscode-server",
    "serverApplicationName": "code-server"
}
EOF

# Create package.json file
cat << EOF > "${SERVER_DIR}/bin/${COMMIT_ID}/package.json"
{
    "name": "code-server",
    "version": "${VSCODE_VERSION}",
    "private": true
}
EOF

# Ensure correct permissions
chown -R root:root "${SERVER_DIR}"
chmod -R 755 "${SERVER_DIR}"

# Set up the server binary
ln -s "${SERVER_DIR}/bin/${COMMIT_ID}/bin/code-server" "/usr/bin/code-server"

echo "VS Code Server setup complete."