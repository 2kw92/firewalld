# firewalld
ДЗ Отус по теме сценарии iptablles


Для проверки дз необходимо выполнить следующие шаги:        
Сачиваем репу и разворачиваем виртуальные машины         
```
git clone https://github.com/2kw92/firewalld
cd firewalld
vagrant up
```      
Стенд развернется со всеми необходимыми настройками       


Для реализации первой части задания использовали утилиту knock.        
Устанваливаем ее на серевр inetRouter. Настравиаем конфиг.      
Файл конфигурации и запуска приложен и имеет следующий вид:        
```
[options]
        UseSyslog

[opencloseSSH]
        sequence      = 2222:tcp,3333:tcp,4444:tcp
        seq_timeout   = 60
        tcpflags      = syn
        start_command = /sbin/iptables -I INPUT -s %IP% -p tcp --dport 22 -j ACCEPT
        cmd_timeout   = 60
        stop_command  = /sbin/iptables -D INPUT -s %IP% -p tcp --dport 22 -j ACCEPT
```       
Далее прописываем правило в iptables:        
```        
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j REJECT
```       
Запускаем сервис:      
```
service knockd start
```       

Далее заходим на сервер centralRouter. Там выполняем         
```
for x in 2222 3333 4444; do sudo nmap -Pn --host_timeout 100 --max-retries 0 -p $x 192.168.255.1; done
ssh vagrant@192.168.255.1
```      
Получаем вот такой вывод,до и после прозвона нужных протов       
```
[root@centralRouter ~]# ssh vagrant@192.168.255.1
ssh: connect to host 192.168.255.1 port 22: Connection refused
[root@centralRouter ~]# for x in 2222 3333 4444; do sudo nmap -Pn --host_timeout 100 --max-retries 0 -p $x 192.168.255.1; done

Starting Nmap 6.40 ( http://nmap.org ) at 2021-01-14 13:29 UTC
Warning: 192.168.255.1 giving up on port because retransmission cap hit (0).
Nmap scan report for 192.168.255.1
Host is up (0.00039s latency).
PORT     STATE    SERVICE
2222/tcp filtered EtherNet/IP-1
MAC Address: 08:00:27:8E:FD:E5 (Cadmus Computer Systems)

Nmap done: 1 IP address (1 host up) scanned in 0.37 seconds

Starting Nmap 6.40 ( http://nmap.org ) at 2021-01-14 13:29 UTC
Warning: 192.168.255.1 giving up on port because retransmission cap hit (0).
Nmap scan report for 192.168.255.1
Host is up (0.00053s latency).
PORT     STATE    SERVICE
3333/tcp filtered dec-notes
MAC Address: 08:00:27:8E:FD:E5 (Cadmus Computer Systems)

Nmap done: 1 IP address (1 host up) scanned in 0.37 seconds

Starting Nmap 6.40 ( http://nmap.org ) at 2021-01-14 13:29 UTC
Warning: 192.168.255.1 giving up on port because retransmission cap hit (0).
Nmap scan report for 192.168.255.1
Host is up (0.00043s latency).
PORT     STATE    SERVICE
4444/tcp filtered krb524
MAC Address: 08:00:27:8E:FD:E5 (Cadmus Computer Systems)

Nmap done: 1 IP address (1 host up) scanned in 0.37 seconds
[root@centralRouter ~]# ssh vagrant@192.168.255.1
vagrant@192.168.255.1's password
```

И успешно заходим на сервер.         

Для реализации второй части задания правим вагрант файл,а именно добавляем строку:       
```
box.vm.network "forwarded_port", guest: 8080, host: 1234, host_ip: "127.0.0.1", id: "nginx"
```       

Для третий части запускаем nginx, в файле centralServer.sh все команды для этого есть     

Для четвертой части на сервере  inetRouter2 добавляем:      
```
iptables -t nat -A PREROUTING -i eth0 -p tcp -m tcp --dport 8080 -j DNAT --to-destination 192.168.0.2:80
iptables -t nat -A POSTROUTING --destination 192.168.0.2/32 -j SNAT --to-source 192.168.255.2
```      

Все гостевые машины ходят в инет через inetRouter для этого добавлены строчки:         
```
echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo "GATEWAY=192.168.255.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1
```    
