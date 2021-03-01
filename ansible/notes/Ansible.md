
---
**NOTAS:** sobre `ansible` 


## Arquivo de configuraçao
    /etc/ansible/ansible.cfg
    vai usar o arquivo caso existe no diretorio padrão
    ou no diretorio home 

## lab access 
``` bash
Login is ssh student1@3.127.116.127 
Password is RUZszeRcMvYcVS
```


## Facts: 
    coleta informações sobre o host alvo, sempre é executado antes de qualquer
     outro modulo ou comando
    para desativar add no playbook
    gather_facts: false

```bash
$ ansible localhost -m setup
localhost | success >> {
  "ansible_facts": {
      "ansible_default_ipv4": {
          "address": "192.168.1.37",
          "alias": "wlan0",
          "gateway": "192.168.1.1",
          "interface": "wlan0",
          "macaddress": "c4:85:08:3b:a9:16",
          "mtu": 1500,
          "netmask": "255.255.255.0",
          "network": "192.168.1.0",
          "type": "ether"
      },
```
## Plays:
     conjunto de tarefas que são excutadas e hosts remotos 

## Playbooks:
     Arquivo que contem uma ou mais tasks


## Comandos
```bash
    $ ansible --version
    $ ansible all --list-hosts


    #checkar sintaxe do yml file
    $ ansible-playbook --syntax-check install_apache.yml

    #rodando playbook
    $ ansible-playbook install_apache.yml




    # check all my inventory hosts are ready to be
    # managed by Ansible
    $ ansible all -m ping
    # The ping module differs from a traditional networking ping and 
    #tests whether Ansible can make an ssh connection to the target 
    #hosts. It is common to use this to test connectivity and as an     #early step in debugging connection issues.



    # collect and display the discovered facts
    # for the localhost
    $ ansible localhost -m setup

    # run the uptime command on all hosts in the
    # web group
    $ ansible web -m command -a "uptime" -o
    # a opção -o retorna o comando em uma unica linha por host
    $ ansible web -m service -a "name=httpd state=stopped" -b

    $ ansible all -m command -a "cat /etc/os-release"
```
## Variaveis:
    Usada em playbooks para mapear valores para serem usados mais de uma 
    vez dentro do codigo 
```yml
---
  - name: Install Apache playbook
    hosts: web
    become: yes
    gather_facts: false
    vars:
    #variavel 1 com uma lista e 2 valores httpd e mod_wsgi
      httpd_packages:
        - httpd
        - mod_wsgi
    #variavel 2 com a msg "This is a test message"
      apache_test_message: This is a test message
      tasks:
       - name: install httpd packages
         yum:
        # pegando a variavel httpd_packages e passando no 
        #loop dentro de item 
          name: "{{ item }}"
          state: present
         loop: "{{ httpd_packages }}"
         notify: restart apache service
```
## Templates:
    Ansible tem a feature de JINJA2 template que permite dinamicamente:
        - setar ou modificar play vars
        - aplicar logica condicional
        - gerar arquivos de configuração baseados em vars
## Roles:
    permite manter e compartilhar de forma mais facil os playbooks
    organizando eles em diretorios
***Exemplo de roles:***
```bash
site.yml
roles/
   common/
     files/
     templates/
     tasks/
     handlers/
     vars/
     defaults/
     meta/
   apache/
     files/
     templates/
     tasks/
     handlers/
     vars/
     defaults/
```
## Ansible galaxy
     site de compartilhamento de ansible roles 


## Exemplo de playbook
```bash
---
- name: install and start apache
  hosts: web
  become: yes
  vars:
    webserver: httpd

  tasks:
  - name: "{{ webserver }} package is present"
    yum:
      name: "{{ webserver }}"
      state: latest
    notify: restart webserver

  - name: latest index.html file is present
    copy:
      src: files/index.html
      dest: /var/www/html/
handlers:
- name: restart webserver
  service:
    name: "{{ webserver}}"
    state: restarted 




```