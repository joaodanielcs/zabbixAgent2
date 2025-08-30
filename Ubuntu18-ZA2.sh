wget https://repo.zabbix.com/zabbix/7.4/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.4+ubuntu18.04_all.deb
dpkg -i zabbix-release_latest_7.4+ubuntu18.04_all.deb
wget https://mirrors.edge.kernel.org/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb
dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb
apt update
wget https://launchpad.net/ubuntu/+archive/primary/+files/libldap-2.4-2_2.4.45+dfsg-1ubuntu1.11_amd64.deb
dpkg -i libldap-2.4-2_2.4.45+dfsg-1ubuntu1.11_amd64.deb
apt --fix-broken install -y
apt install zabbix-agent2 -y
sed -i "s/^Server=.*/Server=192.168.0.105/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/^ServerActive=.*/ServerActive=192.168.0.105/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/^Hostname=.*/Hostname=$(hostname)/" /etc/zabbix/zabbix_agentd.conf
systemctl enable zabbix-agent
systemctl restart zabbix-agent
