#!/bin/bash
#mounts all directories from specified host
#./nfsmount [host] [mountpath]
#unmount is umount -a -t nfs
#all directories created in the specified mount path
#to delete, simply remove your specified mountpath folder

basepath=$2
if [ -z "$2" ]; then
	echo "using default /export"
	basepath="/export"
fi

showmount -e $1 | awk '{if(NR>1)print}' | sed 's/\s.*$//' | while read -r export ; do
	mountdir="$basepath/$(echo $1$export | sed -e 's/\//_/g')"
        if [ ! -d "$mountdir" ]; then
                sudo mkdir -p "$mountdir"
        fi
	echo "mount $1:$export at $mountdir"
	sudo mount -v -t nfs -o proto=tcp,port=2049,async,rw,vers=4.1 "$1:$export" "$mountdir"
done
