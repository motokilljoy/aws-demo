p4python_package:
  pip.installed:
    - name:       p4python
    - upgrade:    True
    - require:
{% if grains['os'] == 'Amazon' %}
      - pkg: python26-devel
{% else %}
      - pkg: python-devel
{% endif %}

python-devel:
  pkg.installed

python26-devel:
  pkg.installed