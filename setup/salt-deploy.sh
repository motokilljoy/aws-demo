#!/bin/bash

# salt-deploy.sh
SALT_ROOT="$1"
PASSWORD="$2"

function die
{
	echo "$1" && exit 1
}

if [ ! -e /srv/salt ] ; then
	ln -s $SALT_ROOT/salt/states /srv/salt
fi

if [ ! -e /srv/pillar ] ; then
	ln -s $SALT_ROOT/salt/pillar /srv/pillar
fi

if [ "$PASSWORD" == "" ]; then
	PASSWORD="pa55wOrd"
fi

echo "syncing salt..."
salt '*' saltutil.sync_all || die "salt sync failed"

echo "refreshing pillar data"
salt '*' saltutil.refresh_pillar || die "refresh pillar failed"

echo "updating mines"
salt '*' mine.update || die "failed to update mine data"

echo "apply salt states..."
# first create the default p4d (the main broker is unconfigured, so no access from the outside yet)
salt 'p4d-host' state.apply || die "failed to apply salt states to the p4d host"
# now configure the super password, configure security, etc.
salt 'p4d-host' p4d.setup $PASSWORD || die "failed to setup p4d host"

# now grab the long timeout token for other services
LTO_TOKEN=$(salt --out=raw 'p4d-host' p4d.get_ticket applications $PASSWORD | sed "s/[^:]*:[ ]*'\([^']*\)'.*/\1/")
if [ ! $? -eq 0 ]; then
	die "failed to get the LTO token"
else
	echo "LTO token for applications is $LTO_TOKEN"
fi

# set up the app server
salt 'app-host' state.apply || die "failed to apply salt states to the app host"
# configure the services
salt 'app-host' app.setup $LTO_TOKEN || die "failed to setup the app host"

# set up the router so it can reach the now-configured services
salt 'master' state.apply || die "failed to setup the master"

# done!
