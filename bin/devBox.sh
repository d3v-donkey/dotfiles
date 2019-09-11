#!/bin/bash

##########################################################################
################### DevBox stack installer for Debian ####################
########################################################################## 



#################  PRE-INSTALL ##################################
echo "Souhaitez-vous installer LAMPP ? [ 'y' ou 'n' ]"
echo "Apache2 / MySql ou MariaDB / PHP / PHPMYADMIN"
read Lampp

echo "Souhaitez-vous installer Atom ? [ 'y' ou 'n' ]"
read Atom

echo "Souhaitez-vous installer Sublime-Text ? [ 'y' ou 'n' ]"
read Subl

echo "Souhaitez-vous installer Android-Studio ? [ 'y' ou 'n' ]"
read Android

echo "Souhaitez-vous installer Visual Studio Code ? [ 'y' ou 'n' ]"
read Code

echo "Souhaitez-vous installer Wordpress ? [ 'y' ou 'n' ]"
read wordpress

if [ "$wordpress" == "y" ]; then
	charset="utf8mb4"

	echo "Afin d'installer Wordpress entrez le nom de la base de données MySQL!  [ Exemple: nomDeVotreSite ]"
	echo "[ Attention au caractére utilisé : charset="utf8mb4" ]"
	read dbname

	echo "Souhaitez-vous créer un nouvel utilisateur associer à la base de données" $dbname "[ 'y' ou 'n' ] "
	read user

	if [ $user == "y" ]; then
		echo "Veuillez entrer le NOM du nouvel utilisateur de la base de données MySQL! (exemple: utilisateur1)"
		read username

		echo "Veuillez entrer le MOT DE PASSE du nouvel utilisateur de la base de données" $dbname
		echo "Remarque: le mot de passe sera masqué lors de la saisie."
		read -s userpass
	fi
fi



################# MISE A JOURS #########################################

sudo apt-get update -y


################# PACKAGES #############################################
sudo apt install npm nodejs filezilla gimp -y


################# ATOM #################################################
if [ "$Atom" == "y" ]; then
	wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -

	echo "
	deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main
	" | sudo tee -a  /etc/apt/sources.list.d/atom.list  > /dev/null 

	sudo apt-get update -y
	sudo apt-get install atom -y

	cd
fi

################# SUBLIME-TEXT #########################################
if [ "$Subl" == "y" ]; then
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -

	echo "
	deb https://download.sublimetext.com/ apt/stable/
	" | sudo tee -a  /etc/apt/sources.list.d/sublime-text.list > /dev/null 

	sudo apt-get update -y
	sudo apt-get install sublime-text -y

	cd
fi

################# ANDROID-STUDIO #######################################
if [ "$Android" == "y" ]; then
	sudo snap install android-studio --classic

	echo '
	[Desktop Entry]
	Version=1.0
	Type=Application
	Name=Android-Studio
	Exec="/snap/bin/android-studio" %f
	Icon=/usr/local/android-studio/bin/studio.png
	Comment=The Drive to Develop
	Categories=Development;IDE;
	Terminal=false
	StartupWMClass=jetbrains-studio
	' | sudo tee -a  /usr/share/applications/android-studio.desktop  > /dev/null 

	cd
fi

################# VS-CODE #######################################
if [ "$Code" == "y" ]; then
	sudo snap install code --classic

	echo '
	[Desktop Entry]
	Name=Visual studio Code
	Exec="/snap/bin/code" %f
	Terminal=false
	Icon=code
	Type=Application
	StartupNotify=true
	Categories=TextEditor;Development;Utility;
	MimeType=text/plain;
	' | sudo tee -a  /usr/share/applications/code.desktop  > /dev/null 

	cd
fi

################# LAMPP #################################################
if [ "$Lampp" == "y" ]; then
	echo "Votre choix : MySql (s) ou MariaDB (m) :"
	read myDatabase

	if [ $myDatabase == 's' ]; then
		## install mysql
		wget http://repo.mysql.com/mysql-apt-config_0.8.13-1_all.deb
		sudo dpkg -i mysql-apt-config_0.8.13-1_all.deb
		sudo apt update -y
		sudo apt install mysql-server -y

	elif [ $myDatabase == 'm' ]; then
		## install mariadb

		sudo apt install mariadb-server mariadb-client

	else
		echo 'Aucun gestionnaire de base de donnée choisi !'

	fi

	# config server sql
	#sudo mysql -e "UPDATE mysql.user SET authentication_string = PASSWORD('toor'), plugin = 'mysql_native_password' WHERE User = 'root' AND Host = 'localhost';"
	#sudo mysql -e "DROP USER 'phpmyadmin'@'localhost'"
	#sudo mysql -e "DROP DATABASE phpmyadmin"
	#sudo mysql -e "FLUSH PRIVILEGES"

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
	sudo usermod -a -G www-data $(whoami)

	# Associer le groupe www-data au dossier /var/www
	sudo chgrp -R www-data /var/www/

	# Donne les droits d'écriture a l'utilisateur
	sudo chown $(whoami):www-data /var/www -R
	# sudo chmod -R g+rwxs /var/www/

	# Créer un lien s'imbolique
	sudo ln -s /var/www ~/www  > /dev/null

	sudo a2ensite phpmyadmin.conf
	sudo systemctl restart apache2
	sudo systemctl restart mysql
fi

################# WORDPRESS  #####################################################

if [ "$wordpress" == "y" ]; then

	if [ -f /root/.my.cnf ]; then

		echo "Création de la base de données MySQL ..."
		mysql -e "CREATE DATABASE ${dbname} /*\!40100 DEFAULT CHARACTER SET ${charset} */;"
		echo "Base de données créée avec succès!"

		echo "Affichage des bases de données existantes ..."
		mysql -e "show databases;"
		echo ""

		if [ $user == "y" ]; then
			echo "Création d'un nouvel utilisateur ..."
			mysql -e "CREATE USER ${username}@localhost IDENTIFIED BY '${userpass}';"
			echo "Utilisateur créé avec succès!"
			echo ""

			echo "Granting ALL privileges on ${dbname} to ${username}!"
			mysql -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${username}'@'localhost';"
			mysql -e "FLUSH PRIVILEGES;"
		fi

		echo "Succèes :)"

	else
		echo "Veuillez entrer le mot de passe utilisateur root MySQL!"
		echo "Remarque: le mot de passe sera masqué lors de la saisie."
		read -s rootpasswd

		echo "Création de la base de données MySQL ..."
		if mysql -uroot -p${rootpasswd} -e "CREATE DATABASE ${dbname} /*\!40100 DEFAULT CHARACTER SET ${charset} */;"; then
			echo "Base de données créée avec succès!"

			echo "Affichage des bases de données existantes ..."
			mysql -uroot -p${rootpasswd} -e "show databases;"
			echo ""

			if [ $user == "y" ]; then
				echo "Création d'un nouvel utilisateur ..."
				mysql -uroot -p${rootpasswd} -e "CREATE USER ${username}@localhost IDENTIFIED BY '${userpass}';"
				echo "Utilisateur créé avec succès!"
				echo ""

				echo "Granting ALL privileges on ${dbname} to ${username}!"
				mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${username}'@'localhost';"
				mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
			fi

			echo "Succèes :)"

		else 
			echo "Erreur dans la création de votre Base de donnée, veuillez recommencé"
		fi

		

	fi

	echo "Installation de WordPress"
	cd /tmp/ && wget -c https://wordpress.org/latest.tar.gz
	tar -xvzf latest.tar.gz
	sudo mv wordpress/ /var/www/html/$dbname
	sudo chown -R www-data:www-data /var/www/html/$dbname/
	sudo chmod 755 -R /var/www/html/$dbname/

	echo "
	<VirtualHost *:80>
		ServerAdmin admin@$dbname.com
		DocumentRoot /var/www/html/$dbname
		ServerName $dbname.com

		<Directory /var/www/html/$dbname>
			Options FollowSymlinks
			AllowOverride All
			Require all granted
		</Directory>

		ErrorLog ${APACHE_LOG_DIR}/$dbname.com_error.log
		CustomLog ${APACHE_LOG_DIR}/$dbname.com_access.log combined

	</VirtualHost>
	" | sudo tee -a /etc/apache2/sites-available/$dbname.conf > /dev/null

	sudo ln -s /etc/apache2/sites-available/$dbname.conf /etc/apache2/sites-enabled/$dbname.conf
	sudo a2enmod rewrite
	sudo systemctl restart apache2

fi





