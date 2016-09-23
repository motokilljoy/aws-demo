perl-Digest-MD5-File:
  pkg.installed
perl-Sys-Syslog:
  pkg.installed
{% if grains['os'] != 'Amazon' %}
gcc-c++:
  pkg.installed
{% endif %}