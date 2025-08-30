apt update 
apt install zabbix-agent2 -y
sed -i "s/^Server=.*/Server=192.168.0.105/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/^ServerActive=.*/ServerActive=192.168.0.105/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/^Hostname=.*/Hostname=$(hostname)/" /etc/zabbix/zabbix_agentd.conf
systemctl enable zabbix-agent
systemctl restart zabbix-agent
