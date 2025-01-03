#!/bin/bash
## GETTING THE BINARIES
## BEFORE INSTALLATION MAKE SURE TO SET PROXY NO_PROXY ENV VAR IF REQUIRED

#Installing Zabbix
wget https://repo.zabbix.com/zabbix/6.0/rhel/8/x86_64/zabbix-release-latest.el8.noarch.rpm
yum localinstall ./zabbix-release-latest.el8.noarch.rpm -y
yum install zabbix-server-mysql zabbix-web-mysql zabbix-nginx-conf zabbix-sql-scripts zabbix-selinux-policy zabbix-agent -y

#Installing MySQL
yum install mysql-server -y
systemctl start mysqld
systemctl enable mysqld

#CONFIGURING THE DATABASE
mysql -uroot -e "create database zabbix character set utf8mb4 collate utf8mb4_bin;"
mysql -uroot -e "create user zabbix@'%' identified by 'zabbix';"
mysql -uroot -e "grant all privileges on zabbix.* to zabbix@'%';"
mysql -uroot -e "set global log_bin_trust_function_creators = 1;"

#LOADING REQUIRED TABLES
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -pzabbix zabbix

mysql -uroot -e "set global log_bin_trust_function_creators = 0;"

#CONFIGURING ZABBIX CONFIGURATIONS
sed -i 's/^# DBPassword=Password$/DBPassword=zabbix/' /etc/zabbix/zabbix_server.conf

#CONFIGURING NGINX CONF
sed -i 's/^#\s*\(listen\s*8080;\)/\1/; s/^#\s*\(server_name\s*example.com;\)/\1/' /etc/nginx/conf.d/zabbix.conf

#STARTING ZABBIX
systemctl restart zabbix-server zabbix-agent nginx php-fpm

#ENABLING ZABBIX
systemctl enable zabbix-server zabbix-agent nginx php-fpm
