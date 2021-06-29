#!/bin/bash
echo 'Inventario das VMs:'
echo '-------------------'
SRV=$(sudo virsh list  | awk '{print $2}' | cut -d "N" -f4)
for vm in $SRV; do
VMIP=$(sudo virsh -q domifaddr $vm | awk '{print $4}' | sed -E 's|/([0-9]+)?$||')


for i in $(seq 1 30); do
    VM_IP=$VMIP
    
    if [ -n "$VM_IP" ]; then
        echo "VMName: $vm IP: $VM_IP"
        echo "$vm ansible_ssh_host=$VM_IP" >> inventory
        break
    fi

   # if [ "$i" == "30" ]; then
   #     echo 'Waited 30 seconds for VM to start, exiting...'
   #     # Inform GitLab Runner that this is a system failure, so it
   #     # should be retried.
   #     exit "$SYSTEM_FAILURE_EXIT_CODE"
   # fi

    sleep 1s
done



done


#for i in $SRV; do
#    
#    VMIP=$(sudo virsh -q domifaddr $i | awk '{print $4}' | sed -E 's|/([0-9]+)?$||')
#    VM_IP=$VMIP
#
#    if [ -n "$VM_IP" ]; then
#        echo "VMName: $i IP: $VM_IP"
#        echo "$i ansible_ssh_host=$VM_IP" >> inventory
#        break
#    fi
#
#    if [ "$i" == "30" ]; then
#        echo 'Waited 30 seconds for VM to start, exiting...'
#        # Inform GitLab Runner that this is a system failure, so it
#        # should be retried.
#        exit "$SYSTEM_FAILURE_EXIT_CODE"
#    fi
#
#    sleep 1s
#done










# Wait for VM to get IP
# Wait for VM to get IP
#echo 'Waiting for VM to get IP'
#for i in $(seq 1 30); do
#    VM_IP=$VMIP
#
#    if [ -n "$VM_IP" ]; then
#        echo "VMName: $1 IP: $VM_IP"
#        break
#    fi
#
#    if [ "$i" == "30" ]; then
#        echo 'Waited 30 seconds for VM to start, exiting...'
#        # Inform GitLab Runner that this is a system failure, so it
#        # should be retried.
#        exit "$SYSTEM_FAILURE_EXIT_CODE"
#    fi
#
#    sleep 1s
#done
