#!/bin/bash

die()
{
	echo "$1" && exit 1
}

# python validated the arguments, but we need a few as well
# basic argument parsing
# -u url  
while [[ $# -gt 1 ]]; do
	key="$1"

	case $key in
    	-u)
		    URL="$2"
		    shift # past argument
		    ;;
    	*)
            die "unused option $key"
            ;;
	esac
		shift # past argument or value
	done

if [ "$URL" == "" ]; then
	die "-u URL is required"
fi

# write to the swarm config file
mkdir -p /opt/perforce/etc/ || die "failed to mkdir"
echo $URL > /opt/perforce/etc/swarm-cron-hosts.conf

# run cron in foreground mode
cron -f
