p4:
  broker:
    base_install: True
    config:
      perforce-broker:
        path:   /etc/perforce/p4broker.conf
        source: salt://p4/broker/files/master_broker.conf.jinja
