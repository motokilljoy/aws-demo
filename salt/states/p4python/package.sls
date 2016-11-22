p4python_package:
  pip.installed:
    - name:       p4python
    - upgrade:    True
{% if grains['os'] == 'Amazon' %}
    - bin_env: /usr/bin/pip-2.7
    - require:
      - pkg: python27-devel
      - pkg: gcc-c++
      - pkg: openssl-devel
{% else %}
    - require:
      - pkg: python27-devel
{% endif %}

{% if grains['os'] == 'Amazon' %}

python27-devel:
  pkg.installed

gcc-c++:
  pkg.installed

openssl-devel:
  pkg.installed

{% else %}

python27-devel:
  pkg.installed

{% endif %}
