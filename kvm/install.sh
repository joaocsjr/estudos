#!/bin/bash
useradd devops
echo 'password' | passwd --stdin devops
echo "instalação concluida"
yum install epel-release -y
yum install htop net-tools -y