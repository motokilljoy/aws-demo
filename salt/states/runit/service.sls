{% from 'runit/map.jinja' import runit with context %}

runit_service:
  service.running:
    - name:     {{ runit.service.name }}
    - enable:   {{ runit.service.enable }}
    - require:
      - pkg:    {{ runit.package.name }}

runit-service-reload:
  module.wait:
    - name:     service.reload
    - m_name:   {{ runit.service.name }}

runit-service-restart:
  module.wait:
    - name:     service.restart
    - m_name:   {{ runit.service.name }}
