docker:
  lookup:
    container:
      swarm:
        name:   'perforce-swarm'
        image:  'dscheirer/swarm:latest'
      swarm-cron:
        name:   'perforce-swarm-cron'
        image:  'dscheirer/swarm-cron:latest'
