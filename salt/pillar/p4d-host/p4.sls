p4:
  server:
    base_install: True
  p4dctl:
    config:
      main:
        source: salt://p4/p4dctl/files/p4d_host_main.jinja
    services:
      running:
        - p4d-main
