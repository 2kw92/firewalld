yum install -y epel-release
yum install -y nmap
echo "net.ipv4.conf.all.forwarding=1" >> /etc/sysctl.conf
echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0 
echo "GATEWAY=192.168.255.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1
systemctl restart network
reboot