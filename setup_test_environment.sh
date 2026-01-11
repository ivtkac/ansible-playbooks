#!/bin/bash

VAGRANT_MACHINE=default
ANSIBLE_CFG_PATH=./ansible.cfg

echo "Up vagrant machine..."
vagrant up $VAGRANT_MACHINE

echo "Fetching vagrant SSH configuration"
vagrant ssh-config $VAGRANT_MACHINE > $VAGRANT_MACHINE.config

VAGRANT_HOST=$(grep "HostName" $VAGRANT_MACHINE.config | awk '{print $2}')
VAGRANT_PORT=$(grep "Port" $VAGRANT_MACHINE.config | awk '{print $2}')
VAGRANT_USER=$(grep "User" $VAGRANT_MACHINE.config | awk '{print $2}')
VAGRANT_PRIVATE_KEY=$(grep "IdentityFile" $VAGRANT_MACHINE.config | awk '{print $2}')

echo "Setting up Ansible configuration"
cat > $ANSIBLE_CFG_PATH <<EOF
[defaults]
inventory = inventory.ini
remote_user = vagrant
host_key_checking = False
private_key_file = $VAGRANT_PRIVATE_KEY
EOF

echo "Creating Ansible inventory file..."
cat > inventory.ini <<EOF
[all]
192.168.56.101
EOF

echo "Inventory file created at inventory.ini"

# Cleanup
rm -f $VAGRANT_MACHINE.config
