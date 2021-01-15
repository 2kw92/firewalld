yum -y install libpcap
rpm -Uvh http://li.nux.ro/download/nux/misc/el7/x86_64/knock-server-0.7-1.el7.nux.x86_64.rpm
echo "net.ipv4.conf.all.forwarding=1" >> /etc/sysctl.conf
yum install -y iptables-services
systemctl start iptables
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X
iptables -t nat -A POSTROUTING ! -d 192.168.0.0/16 -o eth0 -j MASQUERADE
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j REJECT
service iptables save
mv /vagrant/knockd.conf /etc
mv /vagrant/knockd /etc/sysconfig
chown root:root /etc/knockd.conf 
chmod 600 /etc/knockd.conf
chown root:root /etc/sysconfig/knockd
chmod 644 /etc/sysconfig/knockd
echo "192.168.0.0/16 via 192.168.255.2 dev eth1" > /etc/sysconfig/network-scripts/route-eth1
echo "vagrant:vagrant" | chpasswd
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd
service knockd start