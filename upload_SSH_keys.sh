control_private_key=".vagrant/machines/control/virtualbox/private_key"
control_public_key="./_public_key"
control_IP_address="192.168.33.59"
control_local_port="2259"
node1_private_key=".vagrant/machines/node1/virtualbox/private_key"
node1_IP_address="192.168.33.51"
node1_local_port="2251"

#// all host
    echo  ""
    echo  "~/.ssh/known_hosts"
    cat  ~/.ssh/known_hosts

    echo  ""
    echo  "# test connection and set known_host @control"
    ssh  vagrant@localhost  -p $control_local_port  -i $control_private_key \
        'echo "connected to (@control)"'

    echo  ""
    echo  "# test connection and set known_host @node1"
    ssh  vagrant@localhost  -p $node1_local_port  -i $node1_private_key \
        'echo "connected to (@node1)"'

#// @control host

    echo  ""
    echo  "# make private key @control"
    scp -i $control_private_key  -P $control_local_port \
        "$control_private_key" \
        'vagrant@localhost:$HOME/.ssh/id_rsa'
    ssh  vagrant@localhost  -p $control_local_port  -i $control_private_key \
        'ls -l $HOME/.ssh/id_rsa'

    echo  ""
    echo  "# chmod private key @control"
    ssh  vagrant@localhost  -p $control_local_port  -i $control_private_key \
        chmod 600 '$HOME/.ssh/id_rsa'
    ssh  vagrant@localhost  -p $control_local_port  -i $control_private_key \
        'ls -l $HOME/.ssh/id_rsa'

    echo  ""
    echo  "# add host name @control"
    ssh  vagrant@localhost  -p $control_local_port  -i $control_private_key \
        'echo "'$node1_IP_address'  node1"  |  sudo tee -a  "/etc/hosts"  > /dev/null'
    ssh  vagrant@localhost  -p $control_local_port  -i $control_private_key \
        'cat /etc/hosts'

#// @node1 host

    echo  ""
    echo  "# get public key @host"
    ssh-keygen -yf  $control_private_key  |  tr "\n" " "  >  $control_public_key
    echo "vagrant" >> $control_public_key
    cat  $control_public_key

    echo  ""
    echo  "# set authorized_keys @node1"
    ssh  vagrant@localhost  -p $node1_local_port  -i $node1_private_key \
        'echo '"$(cat $control_public_key)"'  >>  $HOME/.ssh/authorized_keys'
    ssh  vagrant@localhost  -p $node1_local_port  -i $node1_private_key \
        'cat $HOME/.ssh/authorized_keys'

#// @control host

    echo  ""
    echo  "# test connection and set known_host @control"
    ssh  vagrant@localhost  -p $control_local_port  -i $control_private_key \
        "ssh -o 'StrictHostKeyChecking no' vagrant@node1  echo  'control connected to node1'  ;  exit"

rm  $control_public_key
