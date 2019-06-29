




en

show running-config
show flash
show version
show ip interface brief

conf t
hostname R1
enable password class
banner motd "
authorized only
"
no ip domain-lookup

line console 0
password cisco
login 

line vty 0 4
password 
login 
transport input telnet
exit

int Fe 0/0
ip addr 192.168.1.1 255.255.255.0
no shutdown
exit

int Ge0/1
ipv6 unicast-routing
ipv6 addr 2001:db8:ab:17::/64
no shotdown
exit




copy running-config startup-config






