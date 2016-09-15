#!/bin/bash

die()
{
	echo "$1" && exit 1
}

# setting up the triggers is a little tricky, so off to python we go
/usr/bin/python /SetupSwarm.py $@

# python validated the arguments, but we need a few as well
# basic argument parsing
# --ip (addr) --id (master/p4d-host/etc.) --wait (URL to aws wait handle) --password (password for p4d super user)
while [[ $# -gt 1 ]]; do
	key="$1"

	case $key in
    	-p)
		    P4PORT="$2"
		    shift # past argument
		    ;;
	    -s)
		    SWARMUSER="$2"
		    shift # past argument
		    ;;
	    -S)
		    SWARMPASS="$2"
		    shift # past argument
		    ;;
	    -H)
		    SWARMHOST="$2"
		    shift # past argument
		    ;;
	    -e)
		    EMAILHOST="$2"
		    shift # past argument
		    ;;
		-u | -P)
			shift
			;;
    	*)
            die "unused option $key"
            ;;
	esac
		shift # past argument or value
	done

# redo the config file
CFGFILE="/opt/perforce/swarm/data/config.php"
/bin/sed -e 's/P4PORT/'$P4PORT'/g' \
		 -e 's/SWARMUSER/'$SWARMUSER'/g' \
		 -e 's/SWARMPASS/'$SWARMPASS'/g' \
		 -e 's/SWARMHOST/'$SWARMHOST'/g' \
		 -e 's/EMAILHOST/'$EMAILHOST'/g' \
		 	/etc/default/swarm/config.php.templ > $CFGFILE 

# make the data dir writeable 
chown www-data:www-data -R /opt/perforce/swarm/data

# disable the default site, enable swarm
a2dissite 000-default
a2ensite swarm
a2enmod rewrite

# run apache in foreground
exec /usr/sbin/apache2ctl -DFOREGROUND