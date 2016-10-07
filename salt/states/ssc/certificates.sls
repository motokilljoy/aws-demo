/etc/pki/p4www.key:
  x509.private_key_managed:
    - bits: 4096
    - new: False

/etc/ssl/p4www.crt:
  x509.certificate_managed:
    - signing_private_key: '/etc/pki/p4www.key'
    - CN: www.example.perforce.cloud.com
    - days_valid: 365
    - backup: True
    - require:
      - pip: m2crypto

/etc/ssl/p4www.pem:
  file.append:
    - sources:
      - file:///etc/pki/p4www.key
      - file:///etc/ssl/p4www.crt
    - require:
      - x509: /etc/ssl/p4www.crt
