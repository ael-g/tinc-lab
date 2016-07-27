tinc:
  pkg:
    - installed     

iperf:
  pkg:
    - installed 

/etc/tinc/tinc.conf:
  file.managed:
    - source:
      - salt://tinc.conf
    - template: jinja
    - makedirs: True

{% for node in salt['pillar.get']('tincconf').keys() %}
/etc/tinc/hosts/{{ node }}:
  file.managed:
    - makedirs: True
    - template: jinja
    - contents: |
        Address = {{ salt['pillar.get']('tincconf:'+node+':public_ip') }}
        Subnet = {{ salt['pillar.get']('tincconf:'+node+':public_ip') }}
        {{ salt['pillar.get']('tincconf:'+node+':public_key')  | indent(8) }}

{% if node == salt['grains.get']('host','') %}
{% set node_conf = salt['pillar.get']('tincconf:'+node) %}
/etc/tinc/rsa_key.priv:
  file.managed:
    - makedirs: True
    - contents_pillar: tincconf:{{node}}:private_key

/etc/tinc/tinc-up:
  file.managed:
    - mode: 750
    - contents: |
        #!/bin/sh
        ip link set $INTERFACE up
        ip addr add {{ node_conf.vpn_ip }}{{node_conf.vpn_subnet}} dev $INTERFACE

/etc/tinc/tinc-down:
  file.managed:
    - mode: 750
    - contents: |
        #!/bin/sh
        ip link set $INTERFACE down

{% endif %}
{% endfor %}
