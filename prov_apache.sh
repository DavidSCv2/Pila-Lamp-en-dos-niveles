#!/bin/bash

#Instalaciones
sudo apt-get update
sudo apt-get install -y apache2 php libapache2-mod-php php-mysql git
sudo apt-get install net-tools


#Clonar repositorio de GitHub
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git /var/www/gestion_usuarios/

#Configuracion para Apache
sudo mv /var/www/gestion_usuarios/src/* /var/www/gestion_usuarios/
sudo chown -R www-data.www-data /var/www/gestion_usuarios/
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/usuarios.conf

sudo sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/gestion_usuarios|' /etc/apache2/sites-available/usuarios.conf

cd /etc/apache2/sites-available
sudo a2ensite usuarios.conf
cd /etc/apache2/sites-enabled
sudo a2dissite 000-default.conf


cat <<EOL > /var/www/gestion_usuarios/config.php
<?php

define('DB_HOST', '192.168.56.20');
define('DB_NAME', 'lamp_db');
define('DB_USER', 'davids');
define('DB_PASSWORD', '1234');

\$mysqli = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);

?>
EOL

#Reinicio del servicio Apache
sudo systemctl reload apache2