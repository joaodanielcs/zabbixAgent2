#!/bin/bash

IP="$1"

apt update
apt install zabbix-agent2 -y

sed -i "s/^Server=.*/Server=$IP/" /etc/zabbix/zabbix_agent2.conf
sed -i "s/^ServerActive=.*/ServerActive=$IP/" /etc/zabbix/zabbix_agent2.conf
sed -i "s/^Hostname=.*/Hostname=$(hostname)/" /etc/zabbix/zabbix_agent2.conf

systemctl enable zabbix-agent2
systemctl restart zabbix-agent2
