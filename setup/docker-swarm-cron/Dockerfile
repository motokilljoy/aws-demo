FROM ubuntu:14.04

RUN apt-get update && apt-get install -y wget

# Add crontab file in the cron directory
ADD swarm-cron /etc/cron.d/swarm-cron
 
# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/swarm-cron
 
# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# the actual thing that does the work
ADD swarm-cron.sh /cron-job.sh

# the thing that configures the job
ADD docker-entrypoint.sh /docker-entrypoint.sh

# need params for the crontab job
ENTRYPOINT ["/bin/bash","/docker-entrypoint.sh"]
