#!/bin/bash

##########################################################################
################### LAMP stack installer for Ubuntu ######################
########################################################################## 



################# Install #################################################

install() {

	sudo apt-get update 
	sudo apt-get upgrade -y

	################# database #################################################
	echo "Votre choix : MySql (s) ou MariaDB (m) :"
	read myDatabase

	if [ myDatabase == 's' ]; then
		## install mysql
		wget http://repo.mysql.com/mysql-apt-config_0.8.13-1_all.deb
		sudo dpkg -i mysql-apt-config_0.8.13-1_all.deb
		sudo apt update -y
		sudo apt install mysql-server -y

	elif [ myDatabase == 'm' ]; then
		echo "Donnez un Password 'fort' à votre compte root MariaDB :"
		read mysqlrootpassword

		sudo apt install mariadb-server mariadb-client



	else
		echo 'Aucun gestionnaire de base de donnée choisi !'

	fi

	# config server sql
	sudo mysql -e "UPDATE mysql.user SET authentication_string = PASSWORD('toor'), plugin = 'mysql_native_password' WHERE User = 'root' AND Host = 'localhost';"
	sudo mysql -e "DROP USER 'phpmyadmin'@'localhost'"
	sudo mysql -e "DROP DATABASE phpmyadmin"
	sudo mysql -e "FLUSH PRIVILEGES"

	################# Apache #################################################
	sudo apt install apache2 apache2-doc -y


	################# PHP ####################################################
	sudo apt install php libapache2-mod-php php-mysql php-curl php-gd \
	php-intl php-json php-mbstring php-xml php-zip php-gettext -y


	################# phpmyadmin + configuration d'apache pour phpmyadmin ###
	wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.zip 
	sudo unzip phpMyAdmin-4.9.0.1-all-languages.zip -d /opt
	sudo mv -v /opt/phpMyAdmin-4.9.0.1-all-languages /opt/phpMyAdmin
	sudo chown -Rfv www-data:www-data /opt/phpMyAdmin

	echo "
	<VirtualHost *:9000>
	ServerAdmin webmaster@localhost
	DocumentRoot /opt/phpMyAdmin
	 
	<Directory /opt/phpMyAdmin>
	Options Indexes FollowSymLinks
	AllowOverride none
	Require all granted
	</Directory>
	ErrorLog ${APACHE_LOG_DIR}/error_phpmyadmin.log
	CustomLog ${APACHE_LOG_DIR}/access_phpmyadmin.log combined
	</VirtualHost>
	" | sudo tee -a /etc/apache2/sites-available/phpmyadmin.conf > /dev/null


	echo "
	Listen 9000
	" | sudo tee -a /etc/apache2/ports.conf > /dev/null


	# S'ajouter au groupe www-data
	# sudo usermod -a -G www-data $(whoami)

	# Associer le groupe www-data au dossier /var/www
	# sudo chgrp -R www-data /var/www/

	# Donne les droits d'écriture a l'utilisateur
	# sudo chown $(whoami):www-data /var/www -R
	# sudo chmod -R g+rwxs /var/www/

	# Créer un lien s'imbolique
	# sudo ln -s /var/www ~/www  > /dev/null

	sudo a2ensite phpmyadmin.conf
	sudo systemctl restart apache2
	sudo systemctl restart mysql

	echo "Installation du serveur Terminer !"

}


################# Remove #################################################

remove() {
	sudo cp -r ~/www ~/.config/www.bak
	sudo cp -r /etc/apache2/sites-available/ ~/.config/www.bak/

	sudo rm -rf ~/www

	sudo apt autoremove --purge mysql-server\* php\* apache2\* 
	sudo apt clean

	echo "Suppression du serveur Terminer !"
	echo "Une Copie du dossier www à été faite dans votre '.config' !"
}


################# vHost #################################################

vHost() {
	echo "Server Name: [Exemple site.fr]"
	read serverName

	echo "Server Admin: [Exemple webmaster@localhost]"
	read serverAdmin

	# serverAlias=${serverName} | sed 's/.\{3\}//'


	# Création du répertoire de travail
	mkdir /var/www/$serverName > /dev/null

	# Renseigner le nom du site dans le "DNS"
	echo "
	127.0.0.1	$serverName
	" | sudo tee -a /etc/hosts > /dev/null

	touch /var/www/$serverName/index.php > /dev/null

	echo "
	<!doctype html>
	<html lang="fr">
		<head>
		    <meta charset="UTF-8">
		    <meta name="viewport" content="width=device-width, initial-scale=1.0">
		    <link rel="stylesheet" href="style.css">
	  		<script src="script.js"></script>
		    <title>Espace public</title>
		</head>
		<body>
			<header>
				<h1>Bienvenue sur votre espace privé.</h1>
		  		<h2>Linux - Apache - MySql - PHP</h2>
			</header>
			<main>
				<?php phpinfo(); ?>
			</main>
			<footer>
				<p>By : </p> <a> https://github.com/d3v-donkey </a>
			</footer>	  
		</body>
	</html>
	" | tee /var/www/$serverName/index.php > /dev/null


	# Création de l'hôte virtuel
	sudo touch /etc/apache2/sites-available/$serverName.conf > /dev/null

	echo "
	<VirtualHost *:80>
	        ServerAdmin $serverAdmin
	        ServerName $serverName
	        #ServerAlias exemple.com
	        DocumentRoot /var/www/$serverName/

	        <Directory />
	                Order Deny,Allow
	                Deny from all
	                Options -Indexes -Includes -ExecCGI -FollowSymlinks
	        </Directory>

	        <Directory /var/www/$serverName/>
	                Order allow,deny
	                allow from all
	                AllowOverride All
	                Options -Indexes -Includes -ExecCGI +FollowSymlinks
	        </Directory>

	        ErrorLog /var/log/apache2/error.log

	        # Possible values include: debug, info, notice, warn, error, crit,
	        # alert, emerg.
	        LogLevel warn

	        CustomLog /var/log/apache2/access.log combined

	        AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css application/javascript

	</VirtualHost>
	" | sudo tee -a /etc/apache2/sites-available/$serverName.conf  > /dev/null


	sudo a2enmod rewrite
	sudo a2ensite $serverName
	#sudo a2dismod mpm_event 
	#sudo a2enmod mpm_prefork

	sudo service apache2 reload
	sudo service mysql reload
}

################# Help #################################################

aide() {
	echo " --- Bienvenue sur Stack Ubuntu Lamp ---

	- Trois Choix disponible

		+ Installation de LAMP pour Ubuntu v.18 - 19

			[sudo chmod +x lamp.sh]
			[./lamp.sh --install]

		+ Désinstallation du serveur
			[sudo chmod +x lamp.sh]
			[./lamp.sh --remove]

		+ Création d'un VirtualHost
			[sudo chmod +x lamp.sh]
			[./lamp.sh --vHost]



	"



}

################# Main #################################################

case "$1" in
    --install)
        install
        ;;
    --remove)
        remove
        ;;
    --vHost)
        vHost
        ;;
    --help)
        aide
        ;;

    *) echo "==>" "[./lamp --help]"; 
esac