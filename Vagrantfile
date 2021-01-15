# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
:inetRouter => {
        :box_name => "centos/7",
        :net => [
                   {ip: '192.168.255.1', adapter: 2, netmask: "255.255.255.248", virtualbox__intnet: "router-net"},
                ]
  },

:inetRouter2 => {
        :box_name => "centos/7",
        :net => [
                   {ip: '192.168.255.2', adapter: 2, netmask: "255.255.255.248", virtualbox__intnet: "router-net"},
                ]
  },

  :centralRouter => {
        :box_name => "centos/7",
        :net => [
                   {ip: '192.168.255.3', adapter: 2, netmask: "255.255.255.248", virtualbox__intnet: "router-net"},
                   {ip: '192.168.0.1', adapter: 3, netmask: "255.255.255.248", virtualbox__intnet: "dir-net"},
                ]
  },
  
  :centralServer => {
        :box_name => "centos/7",
        :net => [
                   {ip: '192.168.0.2', adapter: 2, netmask: "255.255.255.248", virtualbox__intnet: "dir-net"}
                ]
  }
  
}

Vagrant.configure("2") do |config|

  MACHINES.each do |boxname, boxconfig|

    config.vm.define boxname do |box|

        box.vm.box = boxconfig[:box_name]
        box.vm.host_name = boxname.to_s

        boxconfig[:net].each do |ipconf|
          box.vm.network "private_network", ipconf
        end
        
        if boxconfig.key?(:public)
          box.vm.network "public_network", boxconfig[:public]
        end

        box.vm.provision "shell", inline: <<-SHELL
          mkdir -p ~root/.ssh
                cp ~vagrant/.ssh/auth* ~root/.ssh
        SHELL
        
        case boxname.to_s
        when "inetRouter"
          box.vm.provision "shell", path: "inetRouter.sh"
        when "centralRouter"
          box.vm.provision "shell", path: "centralRouter.sh"
        when "centralServer"
          box.vm.provision "shell", path: "centralServer.sh" 
        when "inetRouter2"
          box.vm.network "forwarded_port", guest: 8080, host: 1234, host_ip: "127.0.0.1", id: "nginx"
          box.vm.provision "shell", path: "inetRouter2.sh" 
        end

      end

  end
  
  
end