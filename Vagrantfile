Vagrant.configure("2") do |config|

  #// Common VM settings
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 256  #// MB
  end

  #// synchronized folder
  config.vm.synced_folder ".", "/vagrant",  create: true, owner: "vagrant", group: "vagrant", type:"virtualbox"

  #// function
  def configure(config, address, port)

    config.vm.box = "centos/7"
    config.vm.network :private_network, ip: address
    config.vm.network :forwarded_port, guest: 22, host: port, id: "ssh"

    #// Guest Additions
    config.vbguest.installer_options = { allow_kernel_upgrade: true }  #search: vagrant-vbguest plug-in
  end

  #// Managed node (target server)
  if ! File.exist?('.vagrant/machines/node1') || ! ENV['control_only']
    config.vm.define "node1" do |config|
      configure config, "192.168.33.51", 2251
      config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "1024"]  #// MB
        vb.customize ["modifyvm", :id, "--cpus", "1"]
      end
    end
  end

  #// Control node (server)
  config.vm.define "control" do |config|
    configure config, "192.168.33.59", 2259

    config.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "playbook-0.yml"
      ansible.compatibility_mode = '2.0'
      ansible.raw_arguments = ['--check']
    end
  end

  #// Proxy
  if Vagrant.has_plugin?("vagrant-proxyconf") && ENV['HTTP_PROXY'] && ENV['HTTPS_PROXY']
    config.proxy.http     = ENV['HTTP_PROXY']
    config.proxy.https    = ENV['HTTPS_PROXY']
    config.proxy.no_proxy = "localhost, 127.0.0.1, 192.168.*, 192.168.33.51, 192.168.33.59, control, node*, node1, db*, db1"
  end
end
