# TFE IP Address
ptfe_ip = "192.168.56.33"

Vagrant.configure("2") do |config|
  config.vm.box = "berchev/bionic64"
  config.vm.hostname = "ptfe"
  config.vm.network "private_network", ip: ptfe_ip
  config.vm.provision :shell, path: "scripts/provision.sh", env: { "ip_address" => ptfe_ip }
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024 * 8
    v.cpus = 2
  end
end

