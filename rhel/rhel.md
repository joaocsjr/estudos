# Instalando Ansible AWX no Linux
Este guia abordará a instalção do Ansible AWX. **É recomendavel para ambientes de Teste/Desenvolvimento**.
chama


# Index
- [CentOS](#centos)
    - [Gerenciamento de Usuarios](#Gerenciamento-de-users)
    - [Gerenciamento de Grupos](#Gerenciamento-de-grupos)
    - [Permissoes](#Permissoes)
    - [Criando Usuário](#criando-usuário)
    - [Instalando Python 3](#instalando-python-3)
    - [Instalando pip](#instalando-pip)
    - [Instalando Git](#instalando-git)
    - [Intalando Ansible](#intalando-ansible)
    - [Instalando Docker ](#instalando-docker)
        - [Docker SDK para Python](#docker-sdk-para-python)
        - [Docker Compose](#docker-compose)
    - [Instalando Node e NPM](#instalando-node-e-npm)
    - [Instalando Ansible AWX](#instalando-ansible-awx)
- [Ubuntu](#ubuntu)
- [Para mais Informações](#para-mais-informações)

# CentOS

# Gerenciamento de users

## Comandos:
```bash
id - mostra info sobre o user 
useradd - criacao de users 
usermod - alteracao users 
userdel - delecao de users
# usermod sem o -a remove o user do grupo
usermod -a 

# para bloquear uma conta 
usermod -L vagrant 
#configura conta sem shell, nao permite login no sistema
usermod -s /sbin/nologin vagrant

chage - configura politica de senha para user
```


## Arquivos:
    /etc/passwd -- config users
    /etc/groups --  config grupos
    /etc/shadow -- senhas encriptadas dos users 
    /etc/login.defs -- definicao de politicas (ex tempo de expiracao de senha)


# Gerenciamento de Grupos

## Comandos :
```shell
groupadd --  criacao de grupos 
groupmod -- alterar grupo
groupdel -- deletar grupo
```

## Permissoes
- read (r)=4, write (w)=2, execute (x)=1
- Examine the permissions -rwxr-x---. 
    - user, rwx is calculated as 4+2+1=7.
    - group, r-x is calculated as 4+0+1=5,
    - other users, --- is represented with 0.
    - numerico 750.

- Letters represent permission groups:
    `Who: u (user), g (group), o (other), a (all)`

- Change existing permission set or add new set:
    `What: + (add), - (remove), = (set exactly)`

- Letters represent actual permissions:
    `Which: r (read), w (write), x (execute)`

- Remove read and write permission for group and other on file1:
    ``` chmod go-rw file1```
- Add execute permission for everyone on file2:
    `chmod a+x file2`
- Set read, write, and execute permission for user, read, and execute for group, and no permission for other on sampledir: 
    `chmod 750 sampledir`
- Umask define qual a permissao que um arquivo ou diretorio tera quando for criado 



## Comandos :
```shell
chmod - muda permissao 
chown - mudar owner 
chown :admins foodir # mudar apenas group owner 
chown joao:grupo foodir # mudar user e group  
umask 0
```



# Gerenciamento de processos 

## Comandos :
```shell
kill - sinal PID 
kill -l 
kilall -sinal PID 
pkill  
pgrep 
pgrep -l -u  vagrant
```

## Monitororamento de processos 

- loadAverage calculado entre 1, 5 e 15 minutos 


## Comandos :
```shell
uptime 
top
w
who
ps 
```

## Prioridades de processos

-  processo com o nice level negativo tem maior prioridade
-  apenas o root pode criar um processo com o nice level negativo de -1 a -20



## Comandos 

```bash 
nice -n 15 processo & # criando processo e setando nice level
renice -n -7 $(pgrep processname)
```


# Gerenciamento de Pacotes - YUM


## 



```shell
yum list 
yum help
yum search all 'web server'
yum info httpd 
yum install httpd
yum update
yum update httpd
yum list kernel 
yum remove httpd
yum group list 
yum group install 'Virtualization Server'
yum history 
yum history undo 1 


```

## Gerenciamento de repositorios 

```bash
yum repolist all 
yum-config-manager

```


- Repositorios nao redhat devem ser criados dentro de /etc/yum.repos.d/
- 













## Requisitos do Sistema
- Processador: CPU dual core
- Memória: 4GB de RAM
- Espaço no disco: 20GB de espaço livre

## Requisitos para Instalação
Para aplicação Ansible AWX funcionar corretamente, será necessário:
- Ansible 2.4+
- Recente versão do Docker
- Docker SDK para Python
- Git
- Node versão LTS
- NPM versão LTS

## Criando Usuário
Vamos criar um usuário chamado awx:
```bash
sudo adduser awx
```

Agora escolha uma senha para este usuário:
```bash
sudo passwd awx
# Comfirme a nova senha. É recomendavel usar uma senha forte:
Changing password for user awx.
New password:
Retype new password:
passwd: all authentication tokens updated successfully.
```

Vamos adicionar o usuário no grupo wheel:
```bash
sudo usermod -aG wheel awx
# Por padrão, no CentOS, membros do grupo wheel já são sudo
```

Use o comando `su -` para alternar para a nova conta de usuário:
```bash
sudo su - awx
```

Execute `yum update` para checar se há atulizações, caso tenha estas serão aplicadas:
```bash
sudo yum update -y
```

## Instalando Python 3
Execute o camando abaixo para iniciar a instalção:
```bash
sudo yum install python3 -y
```

Defina Python 3 como padrão:
```bash
sudo alternatives --set python /usr/bin/python3
```

Verifique se ocorreu tudo certo:
```bash
python -V
# Exemplo de saida:
Python 3.6.8
```

## Instalando pip 
Pip é um gerenciador de pacotes que simplifica a instalação e gerenciamento de pacotes escritos em Python.\n Por padrão ele não vem instalado no CentOS.

Adcione repositório EPEL:
```bash
sudo yum install epel-release -y
sudo yum update -y
```

Uma vez que o repositório EPEL foi abillitado, agora podemos instalar pip:
```bash
sudo yum install python-pip -y 
```

Verifique se há alguma atualização. Casa haja, será instalado automaticamente:
```bash
sudo pip install --upgrade pip
```

Verifique se o pip foi instalado:
```bash
pip -V
# Exemplo de saida:
pip 19.3.1 from /usr/lib/python2.7/site-packages/pip (python 2.7)
```

## Instalando Git
Execute o comando abaixo para instalar git:
```bash
sudo yum install git -y
```

Verifique se o git foi instaldo:
```bash
git --version
# Exemplo de saida:
git version 1.8.3.1
```

## Intalando Ansible
Execute o comando abaixo para instalar o Ansible
```bash
sudo yum install ansible -y
```

Teste se foi instalado corretamente:
```bash
ansible localhost -m ping
# Exemplo de saida:
localhost | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

## Instalando Docker 
Vamos desinstalar versões anteriores:
```bash
sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine -y
```

Agora vamos instalar repositório:
```bash
sudo yum install yum-utils  device-mapper-persistent-data lvm2 -y
```  

Use o seguinte comando para definir repositório estavel: 
```bash
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum update -y
```

Agora vamos instalar a ultima versão do Docker Engine - Community:
```bash
sudo yum install docker-ce docker-ce-cli containerd.io -y
```

Inicie o Docker:
```bash
sudo systemctl enable docker
sudo systemctl start docker
```

Verifique se a instalação ocorreu corretamente executando a imagem `hello-word`:
```bash
sudo docker run hello-world
```
Esse comando baixara uma imagem docker e a executara em um container. Se tudo funcionar como esperado,
uma menssagem ira aparecer, parecida com esta:
```
Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

### Docker SDK para Python
Vamos instalar Docker SDK usando pip:
```bash
sudo pip install docker
```
### Docker Compose
Agora vamos baixar a versão estável  do Docker Compose:
```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

Aplique permissões de execução ao binario:
```bash
sudo chmod +x /usr/local/bin/docker-compose
```

Crie um link simbolico para pasta /usr/bin:
```bash
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```

Instale Docker Compose usando pip:
```bash
sudo pip install docker-compose
```

Verifique se instalou corretamente:
```bash
docker-compose --version
# Exemplo de saida:
docker-compose version 1.24.1, build 4667896b
```

## Instalando Node e NPM
Adicione o repositorio Node:
```bash
sudo curl -sL https://rpm.nodesource.com/setup_12.x | sudo bash -
sudo yum update -y
# Caso queira versão Node 10.x apenas mude o setup_12.x para setup_10.x
```

Execute o comando abaixo para instalar Node.js e NPM:
```bash
sudo yum install nodejs -y
```

Verifique se foi instalado corretamanete:
```bash
node -v && npm -v
# Exemplo de saida:
v12.13.0 
6.12.0
```

## Instalando Ansible AWX
Faça clone do repositório AWX project:
```bash
git clone https://github.com/ansible/awx.git
```

Entre na pasta `awx/installer/` e mude para ultima versão estável do projeto:
```bash
cd awx/installer/
git checkout 9.0.0
```
Agora que estou fazendo, a ultima versão é a 9.0.0, [verifique clicando aqui as versões disponiveis](https://github.com/ansible/awx/releases)

Execute o Ansible playbook para instalar as imagens docker:
```bash
sudo ansible-playbook -i inventory install.yml
```

Verifique se as imagens estão funcionado:
```bash
sudo docker ps
```
Saida esperada:
```
CONTAINER ID        IMAGE                        COMMAND                  CREATED              STATUS              PORTS                                                 NAMES
d192aec116cc        ansible/awx_task:9.0.0       "/tini -- /bin/sh -c…"   About a minute ago   Up About a minute   8052/tcp                                              awx_task
0cb0bd7de7cc        ansible/awx_web:9.0.0        "/tini -- /bin/sh -c…"   About a minute ago   Up About a minute   0.0.0.0:80->8052/tcp                                  awx_web
ac0ad49488d0        ansible/awx_rabbitmq:3.7.4   "docker-entrypoint.s…"   About a minute ago   Up About a minute   4369/tcp, 5671-5672/tcp, 15671-15672/tcp, 25672/tcp   awx_rabbitmq
cb8070214384        postgres:10                  "docker-entrypoint.s…"   About a minute ago   Up About a minute   5432/tcp                                              awx_postgres
59c835f20bd5        memcached:alpine             "docker-entrypoint.s…"   About a minute ago   Up About a minute   11211/tcp                                             awx_memcached
```

No browser, abra a aplicação em `http://seu.ip` ou use o comando `curl`:
```bash
curl http://localhost/
```

Quando você abrir a aplicação, Ansible AWX estará atualizando. Logo após aparecera a tela de login.
```
# Por padrão o usuario e senha são:
Username: admin
Password: password
```
# Ubuntu
**EM DESENVOLVIMENTO**

## Para Mais Informações
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#latest-release-via-dnf-or-yum)
- [Ansible AWX](https://github.com/ansible/awx/blob/devel/INSTALL.md#installing-awx)
- [Docker](https://docs.docker.com/install/linux/docker-ce/centos/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Docker SDK](https://pypi.org/project/docker/)