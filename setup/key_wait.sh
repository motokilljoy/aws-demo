#!/bin/bash

COMPLETE_URL="$1"
FORK="$2"

# get the master to accept all of the keys
if [ "$FORK" == "fork" ]; then
	while true ; do
		salt-key -A -y > /dev/null
		COUNT=$(salt-key -l accepted | wc -l)
		if [ "$COUNT" = "4" ] ; then
			echo "all keys have been accepted"
			sleep 5
			salt '*' test.ping
			DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
			sh $DIR/salt-deploy.sh
			RETVAL=$?
			# in AWS you would send a notification to a WaitConditionHandle
			# to let it know if we were successful
			if [ "$COMPLETE_URL" != "" ]; then
				cfn-signal -r 'salt deploy complete' -e $RETVAL "$COMPLETE_URL"
			fi
			exit $RETVAL
		fi
		echo "waiting for salt minions to register"
		salt-key -L | logger
		sleep 5
	done
else
	# fork the shell script
	sh $0 $COMPLETE_URL "fork" | logger &
fi