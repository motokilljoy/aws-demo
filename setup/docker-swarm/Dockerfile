FROM ubuntu:14.04

RUN apt-get update && apt-get install -y wget curl vim php5 apache2 php5-dev libapache2-mod-php5

RUN wget -q https://package.perforce.com/perforce.pubkey -O - | apt-key add -
RUN echo "deb http://package.perforce.com/apt/ubuntu trusty release" > /etc/apt/sources.list.d/perforce.list

RUN apt-get update && apt-get install -y python-dev perforce-cli perforce-p4python helix-swarm helix-swarm-triggers

ADD docker-entrypoint.sh /docker-entrypoint.sh

VOLUME ["/opt/perforce/swarm/data"]

# TODO: lots of required params to set up
ENTRYPOINT ["/bin/bash","/docker-entrypoint.sh"]
EXPOSE 80

ADD SetupSwarm.py /SetupSwarm.py
ADD config.php.templ /etc/default/swarm/config.php.templ
ADD swarm.conf /etc/apache2/sites-available/swarm.conf