m2crypto_package_deps:
  pkg.installed:
    - names:
      - gcc
      - openssl-devel
  {% if grains['os'] == 'Amazon' or grains['os'] == 'CentOS' %}
      - python-devel
  {% else %}
      - python-dev
  {% endif %}

m2crypto_package:
  pip.installed:
    - name: m2crypto
    - upgrade: True
    - require:
      - pkg:  m2crypto_package_deps
