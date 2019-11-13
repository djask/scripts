#!/bin/bash
#adds paths to the system path, for current session
#specify paths in paths.txt or another file of your choice.
#intended for use in bashrc, to mimic how windows stores newpaths

IFS=$'\n'
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
PATHFILE="$DIR/paths.txt"

while IFS= read -r path; do
	if [[ $PATH != *"$path"* ]]; then
		export PATH=$path:$PATH
		echo "path is now $PATH"
	else
		echo "already in path, skipping"
	fi
done < "$PATHFILE"
