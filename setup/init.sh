#!/bin/bash

# init.sh MASTER_IP [ID]

die()
{
	echo "$1" && exit 1
}

MASTER_IP="$1"
ID="$2"

# setup the salt minion (and master)
if [ ! -e /etc/init.d/salt-minion ]; then
	yum install -y wget curl psmisc net-tools || die "failed to install curl"
	curl -o bootstrap_salt.sh -L https://bootstrap.saltstack.com || die "failed to get salt bootstrap"

	OPTS=""
	if [ "$ID" = "master" ]; then 
		OPTS="-M"
	fi

	sh bootstrap_salt.sh $OPTS || die "failed to bootstrap salt"
fi

if [ "$ID" = "master" ]; then 
	sed -i "s/#interface:.*/interface: $MASTER_IP/" /etc/salt/master || die "failed to setup master"
	service salt-master restart || die "failed to restart master"
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	sh $DIR/key_wait.sh
fi

sed -i -e "s/#master:.*/master: $MASTER_IP/" -e "s/#id:.*/id: $ID/" /etc/salt/minion || die "failed to setup minion"
service salt-minion restart || die "failed to restart minion"

