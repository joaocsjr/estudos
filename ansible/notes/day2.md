

# Links importantes:

## Ansible + AWS

https://www.ansible.com/integrations/cloud/amazon-web-services

https://docs.ansible.com/ansible/latest/scenario_guides/guide_aws.html

https://docs.ansible.com/ansible/latest/modules/list_of_all_modules.html

https://docs.ansible.com/ansible/latest/modules/list_of_cloud_modules.html

https://docs.ansible.com/ansible/latest/modules/ec2_module.html

https://docs.ansible.com/ansible/latest/modules/ec2_group_module.html

https://galaxy.ansible.com/docs/contributing/creating_role.html



## Para criar readme.md

https://www.makeareadme.com/






# vim index.html.j2

```html
<html>
<head>
  <title>Giropops Strigus Girus</title>
<body>
  <h1>DESCOMPLICANDO O ANSIBLE - 2020</h1>
  <h2>Esse aqui eh o meu IP: {{ ansible_facts.eth0.ipv4.address  }}</h2>
 </body>
</head>
</html>

```

# vim provisioning/roles/criando-instancias/tasks/provisioning.yml

```yaml 
- name: Criando o Sec Group
  local_action:
    module: ec2_group
    name: "{{ sec_group_name }}"
    description: sg giropops
    profile: "{{ profile }}"
    region: "{{ region }}"
    rules:
    - proto: tcp
      from_port: 22
      to_port: 22
      cidr_ip: 0.0.0.0/0
      rule_desc: SSH
    rules_egress:
    - proto: all
      cidr_ip: 0.0.0.0/0
  register: basic_firewall

- name: Criando a instancia EC2
  local_action: ec2
    group={{ sec_group_name }}
    instance_type={{ instance_type }}
    image={{ image }}
    profile={{ profile }}
    wait=true
    region={{ region }}
    keypair={{ keypair }}
    count={{ count }}
  register: ec2

- name: Adicionando a instancia ao inventario temp
  add_host: name={{ item.public_ip  }} groups=giropops-new
  with_items: "{{ ec2.instances }}"

- name: Adicionando o IP publico da instancia criada ao arquivo hosts
  local_action: lineinfile
    dest="./hosts"
    regexp={{ item.public_ip }}
    insertafter="[kubernetes]" line={{ item.public_ip }}
  with_items: "{{ ec2.instances }}"


- name: Adicionando o IP privado da instancia criada ao arquivo hosts
  local_action: lineinfile
    dest="./hosts"
    regexp={{ item.private_ip }}
    insertafter="[kubernetes]" line={{ item.private_ip }}
  with_items: "{{ ec2.instances }}"

- name: Esperando o SSH
  local_action: wait_for
    host={{ item.public_ip }}
    port=22
    state=started
  with_items: "{{ ec2.instances }}"

- name: Adicionando uma tag na instancia
  local_action: ec2_tag resource={{ item.id }} region={{ region }} profile={{ profile }} state=present
  with_items: "{{ ec2.instances }}"
  args:
    tags:
      Name: ansible-{{ item.ami_launch_index|int + 1 }}


````

# vim provisioning/roles/criando-instancias/vars/main.yml
---
```yaml
# vars file for criando-instancias
instance_type: t2.medium
sec_group_name: giropops
image: ami-0b418580298265d5c
keypair: ansible-class
region: eu-central-1
count: 3
profile: giropops

```yaml


# vim provisioning/main.yml

```yaml
- hosts: local
  roles:
  - criando-instancias

  ````
