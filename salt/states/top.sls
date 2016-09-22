base:
  '*':
    - docker
    - users

  'master':
    - haproxy
    - p4.broker
    - p4.p4dctl

  'p4d-host':
    - p4.server
    - p4python
    - p4.p4dctl
    - p4.client

  'app-host': []
