#!/bin/bash

SLEEPTIME=1

while :
do
	CDATE=`date '+%Y/%m/%d %H:%M:%S'`
	printf "%s\n" "${CDATE}"
        lsof -p $1 | grep IDLE
        printf "\n"

	#sleep ${SLEEPTIME}
done
