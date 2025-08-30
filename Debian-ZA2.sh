#!/bin/bash

IP="$1"
[ -z "$IP" ] && read -p "Qual o IP do servidor Zabbix? " IP
echo "🔄 Atualizando pacotes..."
apt update -y > /dev/null 2>&1
echo "📦 Instalando Zabbix Agent 2..."
apt install zabbix-agent2 -y > /dev/null 2>&1
echo "🔧 Configurando o Zabbix Agent 2..."
sed -i "s/^Server=.*/Server=$IP/" /etc/zabbix/zabbix_agent2.conf
sed -i "s/^ServerActive=.*/ServerActive=$IP/" /etc/zabbix/zabbix_agent2.conf
sed -i "s/^Hostname=.*/Hostname=$(hostname)/" /etc/zabbix/zabbix_agent2.conf

systemctl enable zabbix-agent2 > /dev/null 2>&1
systemctl restart zabbix-agent2 > /dev/null 2>&1
echo "✅ Instalação concluída."
