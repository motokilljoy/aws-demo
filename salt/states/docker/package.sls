{% from 'docker/map.jinja' import docker with context %}

include:
  - docker.pkgrepo

docker_pkg:
  pkg.installed:
    - name:       {{ docker.package.name }}
    - version:    {{ docker.package.version }}
    - refresh:    {{ docker.package.refresh }}
{% if grains['os'] != 'Amazon' %}
    - require:
      - pkgrepo:  docker_package_server
{% endif %}

# Install the python docker modules.
python-pip:
  pkg.installed

docker_py:
  pip.installed:
    - name:       docker-py
    - upgrade:    True
    - require:
      - pkg:      python-pip
