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
	apt-get install -y wget curl psmisc net-tools || die "failed to install curl"
	curl -o bootstrap_salt.sh -L https://bootstrap.saltstack.com || die "failed to get salt bootstrap"

	OPTS=""
	if [ "$ID" = "master" ]; then 
		OPTS="-M"
	fi

	sh bootstrap_salt.sh $OPTS || die "failed to bootstrap salt"
fi

if [ "$ID" = "master" ]; then 
	sed -i "s/#interface:.*/interface: $MASTER_IP/" /etc/salt/master || die "failed to setup master"
	restart_salt master || die "failed to restart master"
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	sh $DIR/key_wait.sh
fi

sed -i -e "s/#master:.*/master: $MASTER_IP/" -e "s/#id:.*/id: $ID/" /etc/salt/minion || die "failed to setup minion"
restart_salt minion || die "failed to restart minion"
