#!/bin/bash

##########################################################################
################### vHost installer for Debian ###########################
########################################################################## 



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

	sudo service apache2 reload
	sudo service mysql reload