#!/bin/bash

# Start SSH service
/usr/sbin/sshd

# Start code-server with SSH key authentication
sudo -u sammy code-server --bind-addr 0.0.0.0:8080 --auth password --password $(cat /home/sammy/.config/code-server/authorized_keys) &

# Keep the container running
tail -f /dev/null