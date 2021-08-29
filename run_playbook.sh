control_private_key=".vagrant/machines/control/virtualbox/private_key"
control_local_port="2259"

ssh  vagrant@localhost  -p $control_local_port  -i $control_private_key \
    "cd /vagrant  &&" \
    'ANSIBLE_FORCE_COLOR=true  ANSIBLE_INVENTORY="/tmp/vagrant-ansible/inventory/vagrant_ansible_local_inventory" ' \
    "ansible-playbook  playbook.yml --diff -v"
