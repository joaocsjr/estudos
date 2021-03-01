# Repositorio de Estudos

** Nem tudo foi testado utilize com cuidado


# Procedimento de instalação e configuração do ansible 


## Maquina controller


```bash
yum install ansible
useradd devops
echo 'r3dh4t1!' | passwd --stdin devops

### criando chaves ssh para acesso sem senha 
ssh-keygen -N '' -f ~/.ssh/id_rsa

### pegando valor da chave 
cat homedouser/.ssh/id_rsa.pub

### Criando user para usar a chave criada
ansible all -m user -a "name=devops" -k 


### copiar como root
ansible all -m authorized_key -a "user=devops state=present key='ssh-rsa '" -k

### configurando o sudoers
ansible all -m lineinfile -a "dest=/etc/sudoers state=present line='devops ALL=(ALL) NOPASSWD: ALL'" -k 

```



**Como alternativa pode ser usado o comando:**


```bash 
ssh-copy-id -i <file> devops@<server>
```


### testar a conexão com o host remoto
`ssh app1.${GUID}.internal`




## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
