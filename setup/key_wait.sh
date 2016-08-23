#!/bin/bash

if [ "$1" = "fork" ]; then
	# get the master to accept all of the keys
	while true ; do
		salt-key -A -y > /dev/null
		COUNT=$(salt-key -l accepted | wc -l)
		if [ "$COUNT" = "4" ] ; then
			logger "all keys have been accepted"
			sleep 5
			salt '*' test.ping | logger
			DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
			sh $DIR/salt-deploy.sh | logger
			# in AWS you would send a notification to a WaitConditionHandle
			# to let it know if we were successful
			exit $?
		fi
		logger "waiting for salt minions to register"
		salt-key -L | logger
		sleep 5
	done
else
	sh $0 "fork" &
fi
