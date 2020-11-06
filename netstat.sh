#!/bin/bash

SLEEPTIME=5

echo "DATE,ESTABLISHED,CLOSE_WAIT,TIME_WAIT,CLOSING,FIN_WAIT1,FIN_WAIT2,IDLE"

while :
do
	CDATE=`date '+%Y/%m/%d %H:%M:%S'`
	printf "%s," "${CDATE}"
	netstat -an -f inet -P tcp | /usr/xpg4/bin/awk 'BEGIN {
			ESTABLISHED = 0;
			CLOSE_WAIT = 0;
			TIME_WAIT = 0;
			FIN_WAIT1 = 0;
			FIN_WAIT2 = 0;
			CLOSING = 0;
			IDLE = 0;
		} {
		if ($1 ~ /61.100.139.17.25/) {
			if ($7 ~ /ESTABLISHED/)
				ESTABLISHED++;
			else if ($7 ~ /CLOSE_WAIT/)
				CLOSE_WAIT++;
			else if ($7 ~ /TIME_WAIT/) 
				TIME_WAIT++;
			else if ($7 ~ /CLOSING/)
				CLOSING++;
			else if ($7 ~ /FIN_WAIT1/)
				FIN_WAIT1++;
			else if ($7 ~ /FIN_WAIT2/)
				FIN_WAIT2++;
		}
		if ($7 ~ /IDLE/) {
			IDLE++;
		}
	} END {
		printf("%d,%d,%d,%d,%d,%d,%d\n",
			ESTABLISHED,
			CLOSE_WAIT,
			TIME_WAIT,
			CLOSING,
			FIN_WAIT1,
			FIN_WAIT2,
			IDLE);
	}'
	sleep ${SLEEPTIME}
done
