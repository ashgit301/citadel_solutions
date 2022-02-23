#!/bin/bash
#creating a inputFile
touch inputFile
#erasing all the pre-existing content 
> inputFile
#check if args are empty or less than 1 
if [ "$1" = "" ] || [ $# -lt 1 ]; then
	for i in $(seq 0 10)
	do
  	  echo "$i," "$(( ( RANDOM % 1000 )  + 1 ))" >> inputFile
	done
else 
	for i in $(seq 0 $1)
	do
	  echo "$i," "$(( ( RANDOM % 1000 )  + 1 ))" >> inputFile
	done
fi
