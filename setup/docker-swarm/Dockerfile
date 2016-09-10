FROM ubuntu:14.04

RUN apt-get update && apt-get install -y wget curl vim php5 apache2 php5-dev libapache2-mod-php5

# make the www-data user id 1000 and the staff ID 2000 so we have the same ID as the apache www-data user
# RUN usermod -u 1000 www-data
# RUN groupmod -g 2000 staff
# RUN usermod -G staff www-data

RUN wget -q https://package.perforce.com/perforce.pubkey -O - | apt-key add -
RUN echo "deb http://package.perforce.com/apt/ubuntu trusty release" > /etc/apt/sources.list.d/perforce.list

RUN apt-get update && apt-get install -y perforce-p4python helix-swarm helix-swarm-triggers

RUN a2enmod rewrite proxy_http

ADD SetupSwarm.py /SetupSwarm.py
ADD DockerHelper.py /DockerHelper.py

# none of this matters, apache needs to be killed
ENTRYPOINT ["/SetupSwarm.py"]
EXPOSE 80
