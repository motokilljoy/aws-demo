docker:
  lookup:
    container:
      swarm:
        name:   'perforce-swarm'
        image:  'dscheirer/swarm:latest'
        options:
          entrypoint: '/bin/bash /docker-entrypoint.sh -p p4d:1666 -u super -P pa55word'
      swarm-cron:
        name:   'perforce-swarm-cron'
        image:  'dscheirer/swarm-cron:latest'
