# Pila-Lamp-en-dos-niveles
## Descripción General

Este proyecto utiliza Vagrant para configurar un entorno de desarrollo virtualizado para una pila LAMP (Linux, Apache, MySQL, PHP). Para ello crearemos dos máquinas virtuales (VM): una para el servidor web Apache y otra para el servidor de base de datos MySQL. Esta configuración permite que una aplicación PHP se conecte al servidor MySQL, con cada máquina contará con susn scripts de aprovisionamiento en Bash para su adecuada configuración.

## Requisitos

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)
- [Git](https://git-scm.com/)

## Estructura del Proyecto

├── Vagrantfile
├── prov_apache.sh
└── prov_mysqls.sh

- **Vagrantfile**: Define las máquinas virtuales y sus configuraciones.
- **prov_apache.sh**: Script de aprovisionamiento para configurar Apache, PHP y los archivos de la aplicación.
- **prov_mysqls.sh**: Script de aprovisionamiento para configurar MySQL y la base de datos.

 ## Vagrantfile

  El `Vagrantfile` está configurado para crear dos VMs: una para el servidor web Apache y otra para el servidor MySQL.

![Configuracion vagrantfile](https://github.com/user-attachments/assets/e023bedf-cc6e-4289-a145-cce77b54b046)

- **config.vm.box**: Definimos el sistema operativo que usaremos en nuestras máquinas, en este caso ubuntu/jammy64.
- **config.vm.define "apache" y config.vm.define "mysql"**: Se define el nombre de la VM.
- **apache(mysql).vm.hostname**: se asigna un nombre para nuestra máquina, DavidSanchezApache para la máquina apache y DavidSanchezMysql para la máquina mysql. 
- **apache.vm.network "forwarded_port"**:  Redirige el puerto 80 de la VM al puerto 8080 en la máquina anfitriona, permitiendo el acceso al servidor Apache a través de http://localhost:8080.
- **apache(mysql).vm.network "private_network"**: Configura una red privada con la IP 192.168.56.10 para la máquina Apache y para Mysql la IP 192.168.56.20, las dos comparten la misma red interna "virtualbox_intnet: redinterna"
- **apache.vm.network "public_network"**: Conecta la VM a una red pública, permitiendo el acceso externo a la red privada.
- **apache(mysql).vm.provision "shell"**: Ejecuta el script prov_apache.sh para configurar la máquina Apache y en caso de la máquina Mysql se ejecutará el script prov_mysql.sh.

## Scripts de aprovisionamiento

Los scripts de aprovisionamiento configuran el software y las configuraciones necesarias para cada VM.

### Aprovisionamiento de Apache (prov_apache.sh)
![prov_apache](https://github.com/user-attachments/assets/648378af-8405-4232-9cbe-8778dbe86c24)

Como podemos ver en la parte de instalaciones, actualizaremos el repositorio, e instalaremos apache, php con las librerias necesarias,las nrt-tools (no necesarias) y git (no necesario).

![status apache2](https://github.com/user-attachments/assets/cdd09d30-0e15-4c53-b22a-205232b0170f)
![phph -v](https://github.com/user-attachments/assets/cccadd86-3148-4da4-9e55-d049dd2bf449)

Lo siguiente que hará el aprovisionamiento será clonar el repositorio a la carpeta indicada, en el caso de no exisistir la carpeta, la creará y cambiamos el usuario y grupo de nuestra carpeta raíz para que Apache pueda acceder a los archivos.

![directorio gestion de usuarios](https://github.com/user-attachments/assets/88c786e6-ac89-4c24-8173-64771e73a66d)

Moveremos los archivos del directorio src a la carpeta raíz gestion_usuarios para que puedan ser directamente accesibles.

![contenido directorio gestion](https://github.com/user-attachments/assets/200d3c4c-b380-4cbd-b1f5-889f2294ba6b)

Crearemos una copia del sitio por defecto de Apache, para que este nuevo archivo sirva a la aplicación, cambiaremos la ruta por la del directorio gestion_usuarios.

![cambio de directorio usuario conf](https://github.com/user-attachments/assets/5c225496-685b-487f-8b79-f3250ffbff4a)
![crear usuarios conf](https://github.com/user-attachments/assets/7084bbf1-839f-422e-a1e5-53941a7b303a)

Para hacer activo el cambio tendremos que habilitar usuarios.conf y deshabilitar el sitio por defecto.

![enable usuarios conf](https://github.com/user-attachments/assets/36e4526a-18b9-47c9-a25e-bc8a0570a473)

Para conectar Apache con la base de datos, configuraremos la conexión con la base de datoscon los datos propios de la misma, contenida en el archivo config.php. (en al aprovisionamiento, en la línea de $mysqli, tendremos que poner una \ para que no lo detecte como una variable)

![config php](https://github.com/user-attachments/assets/7ac36652-1c25-4a03-b046-e77d63b54696)

Por último, para hacer lso cambios efectivos, reiniciaremos el servivio de Apache.

### Aprovisionamiento de Mysql (prov_mysql.sh)
![prov_mysql](https://github.com/user-attachments/assets/04dc8f81-d2ea-44d1-9fed-b9564fdcab76)

Al igual que en el aprovisionamiento de Apache, actualizaremos el repositorio e instalaremos las net-tools, aunque en esta tendremos que instalar el servicio de MySQL para la base de datos.

![status mysql](https://github.com/user-attachments/assets/b4f357bf-6970-410d-b442-0e622e8323d2)

En este aprovisionamiento también clonaremos el repositorio, ya que la base de datos que vamos a usar se encuentra en el directorio db del archivo clonado.
Importaremos la base de datos y crearemos un usuario, pero para ello nos logeraremos como root usando sudo su.

![lamp_db](https://github.com/user-attachments/assets/64a2e86e-c6da-4f37-984b-26b116af8cc7)

Para crear nuestro usuario, pondremos el nombre que queramos, en este caso davids, y como la conexión se establecerá desde la máquina Apache, pondremos la IP de esta, la contraseña elegida, y pondremos la base de datos que hemos inportado, lamp_db.

![uusario davids](https://github.com/user-attachments/assets/1b4c7117-3bad-4a79-a602-16791885cf9b)

Para permitir conexiones a otras máquinas desde MySQL, tendremos que cambiar la bind-address a la de la propia máquina mysql.

![bind address](https://github.com/user-attachments/assets/61b56d02-b18b-4b52-a88c-154fa6c52ec2)

## Resultado
A través de un navegador, nos conectaremos a nuestra aplicación poniendo hhtp://localhost:8080

![Lamp](https://github.com/user-attachments/assets/a449bc02-9a7a-408d-86ed-01009820aaef)

Para ver que está completamente funcional, crearemos un usuario.

![creacion usuario](https://github.com/user-attachments/assets/41fa999a-f09c-4c23-ac4a-f27124be29fb)
![usuario creado](https://github.com/user-attachments/assets/5bd57349-4953-43ab-a4a3-2a7a8f26f505)

Comprobaremos en nuestra base de datos que el usuario creado se ha añadido.

![pablo](https://github.com/user-attachments/assets/1253ecff-73e9-41ae-80a7-5429a853f80c)

## Como usar el proyecto
-**Clonar el proyecto**

-**Ejecutar vagrant up --provision para crear las máquinas y configurarlas**

-**Accede al servidor Apache a través de http://localhost:8080**

-**Usar la aplicación**

## Conclusión
Este proyecto en Vagrant proporciona una estructura para desplegar una pila LAMP en dos niveles, una VM dedicada a servidor web y otra con la base de datos, que simula un entorno real para pruebas o desarrollo.












