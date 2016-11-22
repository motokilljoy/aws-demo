m2crypto_package_deps:
  pkg.installed:
    - names:
      - gcc
      - openssl-devel
  {% if grains['os'] == 'Amazon' %}
      - python27-devel
  {% elif grains['os'] == 'CentOS' %}
      - python27-devel
  {% else %}
      - python27-devel
  {% endif %}

m2crypto_package:
  pip.installed:
    - name: m2crypto
    - upgrade: True
    - require:
      - pkg:  m2crypto_package_deps
