## Procedimento de instalação e configuração do ansible na maquina manager e hosts


Maquina controller

1. `yum install ansible`
2. `useradd devops`
3. `echo 'r3dh4t1!' | passwd --stdin devops`


### criando chaves ssh para acesso sem senha 

`ssh-keygen -N '' -f ~/.ssh/id_rsa`
\
### pegando valor da chave 
`cat homedouser/.ssh/id_rsa.pub`


### Criando user para usar a chave criada
`ansible all -m user -a "name=devops" -k `

### copiar como root
`ansible all -m authorized_key -a "user=devops state=present key='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCfRkvxTkjND3x/Z6aii5di8SnRAV8gjVFAnHwwi1LTCnC3igF28dWL5wpXXFcNdsDYUf1+GgdfZw9NPhj3TtgetFA06ZziXAxIkatLNF04P+HlDH/CpO5EqWUQlq8yktBj/l0nNU8gqXxYGyHljF/jiP5q1apUXbnWdGufaTOZnnBuqsp2Kls4R+jA5VT+HO/8sIGW0O/3RXHEO4+YjQL4eTC59PfhxZ4jBmB0m03KEYwEd0875oM38g27CBGDaVPekdNROvtZVNtWDAwykjhn3dCRAjRZdYxoZst9J13Yxym5laKoAJSa2bkCvrhmP1jWihE9Xy/qojcMyLLC6GxK5SaeNwshehZzoIEyKnEX6guKQeAyFZRjhlj44R0irKjWmQv/chh3E2JZL4mktub3JD3AJWG+poZ2RxXZuS5Vul189WUzceBxYIVOuhwn1xj23Wb0OcXmx8AAZ7uc/jvWgEr+VpkQ5NbudwAbOSdGhvR9q0gFydqmspI1gPlI2as= jcastro@bluemoon.local'" -k`

### configurando o sudoers
`ansible all -m lineinfile -a "dest=/etc/sudoers state=present line='devops ALL=(ALL) NOPASSWD: ALL'" -k `


### testar a conexão com o host remoto
`ssh app1.${GUID}.internal`


ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcbfA/8LNtC6EPVxebOwReqb88eVHP6+Lwzv9D/T0VJ34IHKfwLJDCHwsFEMaQHJgH7/UqlxelxeafCqvJ93fyd7xEy9u+X8fW4yHwU6+8BDtpsDoJJEME6yzUCT0bVSoQXQUl9AjMhbi0UBcKmQXIyBI59u5nJRAagMdRVHMDPRR8XcuU0uvR+Q2DAg5pAcLYVpGM9AckRITcQCMhjGAhOsokWBR4rXaD0t14qyt+ap8jGzE/EQNEGb64xJmjRAMBpOBqhuCVeAR/LYrZmMiQ3JgxYxLXAUjea28qr/u77Ipynsxh4hIEGKVCYNqYsJIPi/qNZ8XjhT5uaw79kA91 devops@ansible



*validando acesso via ansible*
`ansible all -m ping`

{{< admonition warning "Warning" true >}}
esxi02: Failed to resolve image: Http request failed. Code 400: ErrorType(2) failed to do request: Head https://harbor-dev.jarvis.lab/v2/ghost/ghost/manifests/3.25.0: x509: certificate signed by unknown authority
{{< /admonition >}}
