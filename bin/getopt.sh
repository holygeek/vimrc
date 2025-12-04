#!/bin/sh

me=$(basename $0)

usage() {
	echo "usage: $me [-h] ...
Options:
	-h
	  Help"
}

foo=
while getopts hf: opt
do
	case "$opt" in
		f) foo=$OPTARG;;
		h) usage; exit ;;
		\?) echo Unknown option ; exit;;
	esac
done
shift $(($OPTIND -1))
