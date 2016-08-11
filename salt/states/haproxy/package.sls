{% from 'haproxy/map.jinja' import haproxy with context %}

haproxy_package:
  pkg.installed:
    - name:     {{ haproxy.package.name }}
    - version:  {{ haproxy.package.version }}
    - refresh:  {{ haproxy.package.refresh }}
