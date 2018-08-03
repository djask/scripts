#!/bin/bash
#adds paths to the system path, for current session
#specify paths as system arguments

for path in "$@"; do
	if [[ $PATH != *"$path"* ]]; then
		export PATH=$path:$PATH
		echo "path is now $PATH"
	else
		echo "already in path, skipping"
	fi
done
