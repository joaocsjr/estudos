#!/bin/bash

ansible-playbook kvm/kvm.yaml -i kvm/inventory 
bash kvm/ip.sh