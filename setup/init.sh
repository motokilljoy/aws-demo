#!/bin/bash

# init.sh MASTER_IP [ID]

die()
{
	echo "$1" && exit 1
}

restart_salt()
{
	# $1 is master or minior
	SALT_TYPE=$1
	service salt-$SALT_TYPE stop || die "failed to stop $SALT_TYPE"
	# sometimes python takes a bit to stop-stop
	RETRY=100
	for ITER in `seq 1 $RETRY`;
	do
		ps aux|grep python|grep -q salt-$SALT_TYPE
		if [ $? -eq 1 ]; then
			service salt-$SALT_TYPE start || die "failed to start $SALT_TYPE"
			return 0
		fi
		echo "Waiting for salt-$SALT_TYPE to stop"
		sleep 1
	done

	return 1
}

MASTER_IP="$1"
ID="$2"

# setup the salt minion (and master)
if [ ! -e /etc/init.d/salt-minion ]; then
	yum install -y wget curl psmisc net-tools || die "failed to install curl"
	curl -o bootstrap_salt.sh -L https://bootstrap.saltstack.com || die "failed to get salt bootstrap"

	OPTS=""
	if [ "$ID" = "master" ]; then 
		yum install -y python-pygit2 python-yaml || die "Failed to install python support on master."
		OPTS="-M -J {\"interface\":\"$MASTER_IP\",\"gitfs_remotes\":[\"https://github.com/robinsonj/perforce-formula\"],\"fileserver_backend\":[\"git\",\"roots\"]}"
	fi

	# umm, sometimes this appears to fail even though it's working?
	# the salt bootstrap code is prone to breaking, so either probably
	# find a version that works and only use that one
	bash bootstrap_salt.sh $OPTS
fi

if [ "$ID" = "master" ]; then 
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	sh $DIR/key_wait.sh
fi

sed -i -e "s/#master:.*/master: $MASTER_IP/" -e "s/#id:.*/id: $ID/" /etc/salt/minion || die "failed to setup minion"
restart_salt minion || die "failed to restart minion"
