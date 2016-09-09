#!/bin/bash

# salt-deploy.sh
SALT_ROOT="$1"

if [ ! -e /srv/salt ] ; then
	ln -s $SALT_ROOT/salt/states /srv/salt
fi

if [ ! -e /srv/pillar ] ; then
	ln -s $SALT_ROOT/salt/pillar /srv/pillar
fi

echo "syncing salt..."
salt '*' saltutil.sync_all

echo "refreshing pillar data"
salt '*' saltutil.refresh_pillar

echo "updating mines"
salt '*' mine.update

echo "apply salt states..."
salt '*' state.apply

# now...make a p4d or something?
echo "making the default p4d instance"
salt '*' p4d.create default
