#!/bin/bash

dirpath=$(pwd)
mask="*"
number_cores=$(grep processor /proc/cpuinfo | wc -l)
command=""

while [ -n "$1" ] 
do
	case "$1" in
		--path) 
			dirpath="$2"
			shift ;;
		--mask) 
			param="$2"
			shift ;;
		--number) 
			number_cores="$2"
			shift ;;
		*)
			command="$1"
	esac
	shift
done

for file in $(find "$dirpath" -name "$mask"); do
	proc_count=$(jobs | wc -l | xargs)
	if (( proc_count == number_cores )); then
		wait -n
	fi
	eval "$command $file && sleep 1 &"
done
