## Day 1 do curso descomplicando ansible 


Maquina controller

1. `yum install ansible`
2. `useradd devops`
3. `echo 'r3dh4t1!' | passwd --stdin devops`


### Comandos usados
```bash 


mkdir ansible
  cd ansible/
  vim hosts
  vim /etc/hosts
  ping elliot-02
  ping elliot-03
  ping elliot-01
  sudo apt-get install software-properties-common
  sudo apt-add-repository ppa:ansible/ansible
  sudo apt-get update
  sudo apt-get install ansible
  ansible --version
  vim /etc/ansible/ansible.cfg
  ansible -i hosts all -m ping
  ansible -i hosts elliot-03 -m ping
  ansible -i hosts elliot-03 -m ping -k
  ansible -i hosts giropops -m ping -k
  ansible -i hosts webservers -m ping
  ansible -i hosts webservers -a "/sbin/ifconfig"
  ansible -i hosts webservers -a "bash -c 'uptime'"
  ansible -i hosts webservers -m copy "src=hosts dest=/tmp"
  ansible -i hosts webservers -m copy -a "src=hosts dest=/tmp"
  ansible -i hosts webservers -m shell -a "uptime"
  ansible -i hosts webservers -m git -a "repo=https://github.com/badtuxx/giropops-monitoring.git dest=/tmp/git"
  ansible -i hosts webservers -m setup
  ansible -i hosts elliot-02 -m setup
  ansible -i hosts elliot-02 -m setup -a "filter=ansible_distribution"
  ansible -i hosts all -m apt -a "name=vim state=present"
  ansible -i hosts all -b -m apt -a "name=vim state=present"
  vim nginx_playbook.yml
  ansible-playbook -i hosts  nginx_playbook.yml -b
  ansible-playbook -i hosts  nginx_playbook.yml
  vim nginx.conf
  vim index.html.j2
  vim index.html

   ```

```yaml
# cat nginx_playbook.yml
---
- hosts: webservers
  become: yes
  remote_user: ubuntu
  tasks:
  - name: Instalando o nginx
    apt:
      name: nginx
      state: latest
      update_cache: yes
  - name: Iniciando o nginx
    service:
      name: nginx
      state: started
  - name: Copiando index.html personalizado
    template:
      src: index.html.j2
      dest: /var/www/html/index.html
  - name: Copiando nginx.conf
    copy:
      src: nginx.conf
      dest: /etc/nginx/nginx.conf
    notify: Restartando o Nginx
  handlers:
  - name: Restartando o Nginx
    service:
      name: nginx
      state: restarted
```






```html
# cat index.html
<html>
<head>
  <title>GIROPOPS STRIGUS GIRUS!</title>
<body>
  <h1>DESCOMPLICANDO O ANSIBLE!</h1>
</body>
</head>
</html>
```
