tinc:
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
        {{ salt['pillar.get']('tincconf:'+node+':public_key') }}
{% endfor %}
