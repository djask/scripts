#!/bin/bash
#mounts all directories from specified host
#./nfsmount [host] [mountpath]
#unmount is umount -a -t nfs
#all directories created in the specified mount path
#to delete, simply remove your specified mountpath folder

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

basepath=$2
if [ -z "$2" ]; then
	echo "using default /export"
	basepath="/export"
fi

for export in `showmount -e $1 | awk '{if(NR>1)print}' | sed 's/\s.*$//'`; do
	mountdir="$basepath/$(echo $1$export | sed -e 's/\//_/g')"
	printf "mount $1:$export at $mountdir?: "
	read response
	if ! [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
		continue
	fi
        if [ ! -d "$mountdir" ]; then
        	mkdir -p "$mountdir"
        fi
	mount -v -t nfs -o proto=tcp,port=2049,async,rw,vers=4.1 "$1:$export" "$mountdir"
	echo "mount success"
done
