#!/bin/bash

username=$1
host=$2
mount_dir=$3

if [ $# -eq 0 ]; then
	echo "usage: sshfs_mount.sh [user] [host] [mount_dir]"
fi

echo "connecting to $username@$host, mounting on $mount_dir"

sshfs $1@$2:. $3 -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3
