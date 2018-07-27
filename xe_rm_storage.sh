#!/bin/bash
#this script removes storage based on name-label
#usage ./xe_rm_storage.sh [label]

temp=$(xe sr-list name-label="$1" | grep uuid)
sr_uuid=${temp##*: }

if [[ "$sr_uuid" ]]; then
        echo "found storage $1 with uuid $sr_uuid"
	printf "choose $sr_uuid ? (y/n) "
	read choice
	if [ $choice != 'y' ]; then
		echo "exiting"
		exit 1
	fi
else
	echo "no choices found, are you sure you entered a valid label?"
	exit 1
fi

temp=$(xe pbd-list sr-uuid="$sr_uuid" | sed -n 1p)
pbd_uuid=${temp##*: }

if [[ "$pbd_uuid" ]]; then
        echo "found pdb associated with storage, uuid $pbd_uuid"
	printf "remove $pbd_uuid ? (y/n) "
	read choice
	if [ $choice != 'y' ]; then
		echo "exiting"
		exit 1
	fi
else
	printf "no pbd found, something went wrong"
	exit 1
fi

echo "unplugging $pbd_uuid..."
xe pbd-unplug uuid="$pbd_uuid"

echo "detaching storage $1..."
xe sr-forget uuid="$sr_uuid"
