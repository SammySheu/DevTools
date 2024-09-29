#!/bin/bash

# Start SSH service
/usr/sbin/sshd

# Start VSCode Server
/tmp/vscode-server-setup.sh &

# Keep the container running
tail -f /dev/null