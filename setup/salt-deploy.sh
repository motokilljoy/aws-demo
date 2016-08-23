#!/bin/bash

# salt-deploy.sh  --  sync the s3 sources (maybe) and configure everyone via salt

if [ ! -e /srv/salt ] ; then
	aws --region=us-west-1 --no-sign-request s3 sync s3://perforce-doug-test/salt-for-aws-cf/salt /srv/salt
fi

echo "syncing salt..."
salt '*' saltutil.sync_all

echo "apply salt states..."
salt '*' state.apply

# now...make a p4d or something?
echo "making the default p4d instance"
salt '*' p4d.create default
