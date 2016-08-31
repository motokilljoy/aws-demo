{% from 'docker/map.jinja' import docker with context %}

{% if grains['os'] != 'Amazon' %}
include:
  - docker.pkgrepo
{% endif %}

docker_pkg:
  pkg.installed:
{% if grains['os'] == 'Amazon' %}
    - name:       docker
{% else %}
    - name:       {{ docker.package.name }}
{% endif %}
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
