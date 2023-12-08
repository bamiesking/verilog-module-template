#!/bin/bash

case $# in

1)
	FILE_FROM=module
	FILE_TO=$1
	;;

2)
	FILE_FROM=$1
	FILE_TO=$2
	;;

*)
	echo Invalid arguments. Please provide either a single argument \(destination_name\), or two arguments \(origin_name, destination_name\).
	exit 1
	;;
esac

for FILE in $(ls $FILE_FROM.*); do
	mv $FILE "${FILE/$FILE_FROM/$FILE_TO}"
done

sed -i -e "s/moduleName = $FILE_FROM/moduleName = $FILE_TO/g" Makefile
sed -i -e "s/module $FILE_FROM/module $FILE_TO/g" "$FILE_TO.v"
sed -i -e "s/V$FILE_FROM/V$FILE_TO/g" "$FILE_TO.cpp"
