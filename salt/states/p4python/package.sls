p4python_package:
  pip.installed:
    - name:       p4python
    - upgrade:    True
    - require:
      - pkg: python-devel

python-devel:
  pkg.installed