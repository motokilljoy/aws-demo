#!/bin/bash

die()
{
	echo "$1" && exit 1
}

MASTER="$1"

# setup the salt minion (and master)
if [ ! -e /etc/init.d/salt-minion ]; then
	apt-get update && apt-get install -y curl || die "failed to install curl"
	curl -o bootstrap_salt.sh -L https://bootstrap.saltstack.com || die "failed to get salt bootstrap"

	OPTS=""
	if [ "$MASTER" = "master" ]; then 
		OPTS="-M"
	fi

	sh bootstrap_salt.sh $OPTS || die "failed to bootstrap salt"
fi

if [ "$MASTER" = "master" ]; then 
	sed -i "s/#interface:.*/interface: 192.168.44.101/" /etc/salt/master || die "failed to setup master"
	service salt-master restart || die "failed to restart master"

	sh /vagrant/setup/key_wait.sh
fi

sed -i "s/#master:.*/master: 192.168.44.101/" /etc/salt/minion || die "failed to setup minion"
service salt-minion restart || die "failed to restart minion"

