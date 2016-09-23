p4python_package:
  pip.installed:
    - name:       p4python
    - upgrade:    True
    - require:
{% if grains['os'] == 'Amazon' %}
      - pkg: python27-devel
{% else %}
      - pkg: python-devel
{% endif %}

python-devel:
  pkg.installed