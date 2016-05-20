hosts = {
  "test" => "192.168.1.50"
}

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/wily64"
  config.ssh.insert_key = false
  hosts.each do |name, ip|
    config.vm.define name do |vm|
      vm.vm.hostname = "%s" % name
      # vm.vm.network "private_network", ip: ip
      vm.vm.network "public_network", bridge: "wlan0", ip: ip
      config.vm.network "forwarded_port", guest: 3000, host: 3000, auto_correct: true
      vm.vm.provider "virtualbox" do |v|
        v.name = name
        v.memory = 2560
      end
      vm.vm.provision "shell", path: "provisioning.sh"
    end
  end
end