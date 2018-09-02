#!/bin/bash
#mounts all directories from specified host
#./nfsmount [host] [mountpath]
#unmount is umount -a -t nfs4
#all directories created in the specified mount path
#to delete, simply remove your specified mountpath folder

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

basepath=${2%/}
if [ -z "$2" ]; then
	echo "using default /import"
	basepath="/import"
fi

for import in `showmount -e $1 | awk '{if(NR>1)print}' | sed 's/\s.*$//'`; do
	#style1 directory paths with server hostnames and full paths
	#mountdir="$basepath/$(echo $1$import | sed -e 's/\//_/g')"

	#style 2 mounting with only the base folder path for shorter filepaths
	mountdir="$basepath/$1/$(basename $import)"
	printf "mount $1:$import at $mountdir?: "

	read response
	if ! [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
		continue
	fi

	#make mountdir if not already existing
        if [ ! -d "$mountdir" ]; then
        	mkdir -p "$mountdir"
        fi

	#do the mount operation
	mount -v -t nfs -o rw,bg,hard,nointr,user,noauto,rsize=1048576,wsize=1048576,tcp,timeo=10 "$1:$import" "$mountdir"
done
