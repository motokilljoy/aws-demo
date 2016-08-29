#!/bin/bash

# salt-deploy.sh

if [ ! -e /srv/salt ] ; then
	ln -s /tmp/aws-demo/salt/states /srv/salt
fi

if [ ! -e /srv/pillar ] ; then
	ln -s /tmp/aws-demo/salt/pillar /srv/pillar
fi

echo "syncing salt..."
salt '*' saltutil.sync_all

echo "apply salt states..."
salt '*' state.apply

# now...make a p4d or something?
echo "making the default p4d instance"
salt '*' p4d.create default
