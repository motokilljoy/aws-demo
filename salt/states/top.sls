base:
  '*':
    - docker
    - users

  'master':
    - haproxy
    - p4.broker

  'p4d-host':
    - p4.server

  'app-host': []
