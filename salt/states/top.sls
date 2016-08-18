base:
  '*':
    - docker

  'master':
    - haproxy
    - p4.broker
    - runit

  'p4d-host':
    - p4.server

  'app-host': []
