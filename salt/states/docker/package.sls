{% from 'docker/map.jinja' import docker with context %}

include:
  - docker.pkgrepo

docker_pkg:
  pkg.installed:
    - name:       {{ docker.package.name }}
    - version:    {{ docker.package.version }}
    - refresh:    {{ docker.package.refresh }}
    - require:
      - pkgrepo:  docker_package_server
