#!/bin/bash

#Instalaciones
sudo apt-get update
sudo apt-get install -y mysql-server 
sudo apt-get install net-tools


#Activar servicio de MySQL
sudo service mysql start

#Clonar repositorio de GitHub
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git 

#Configuracion de la base de datos
sudo su
mysql -u root < iaw-practica-lamp/db/database.sql
mysql -u root  <<EOF
CREATE USER 'davids'@'192.168.56.10' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON lamp_db.* TO 'davids'@'192.168.56.10';
FLUSH PRIVILEGES;
EOF

#Cambiar bind-address
sudo sed -i 's/^bind-address\s*=.*/bind-address = 192.168.56.20/' /etc/mysql/mysql.conf.d/mysqld.cnf

#Reinicio del servicio MySQL
sudo systemctl restart mysql
