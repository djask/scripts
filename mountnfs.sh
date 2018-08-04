#!/bin/bash
#mounts all directories from specified host
#./nfsmount [host] [mountpath]
#unmount is umount -a -t nfs
#all directories created in the specified mount path
#to delete, simply remove your specified mountpath folder

showmount -e $1 | awk '{if(NR>1)print}' | sed "s/\*//g" | while read -r export ; do
	mountdir="$2/$(echo $1$export | sed -e 's/\//_/g')"
        if [ ! -d "$mountdir" ]; then
                mkdir -p "$mountdir"
        fi
	echo "mount $1:$export at $mountdir? (y/n) "
	read choice	
	if [ $choice == 'y' ]; then
		sudo mount -v -t nfs -o proto=tcp,port=2049,async,rw,vers=4.0 "$1:$export" "$mountdir"
	fi
done
