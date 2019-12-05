#!/bin/bash

##########################################################################
################### DevBox stack installer for Debian ####################
########################################################################## 

DIR=`pwd`


devBox() {
	#################  PRE-INSTALL ##################################
	echo "Souhaitez-vous installer LAMPP ? [ 'y' ou 'n' ]"
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

	################# MISE A JOURS #########################################

	sudo apt-get update -y


	################# PACKAGES #############################################
	sudo apt install npm nodejs filezilla gimp krita algobox composer zeal idle3 -y
	sudo npm install npm@latest -g


	################# ATOM #################################################
	if [ "$Atom" == "y" ]; then
		sudo snap install atom --classic

		echo '
		[Desktop Entry]
		Name=Atom
		Exec="/snap/bin/atom" %f
		Terminal=false
		Icon=code
		Type=Application
		StartupNotify=true
		Categories=TextEditor;Development;Utility;
		MimeType=text/plain;
		' | sudo tee -a  /usr/share/applications/atom.desktop  > /dev/null
	fi

	################# SUBLIME-TEXT #########################################
	if [ "$Subl" == "y" ]; then
		sudo snap install sublime-text --classic

		echo '
		[Desktop Entry]
		Name=Sublime Text 3
		Exec="/snap/bin/sublime-text.subl" %f
		Terminal=false
		Icon=code
		Type=Application
		StartupNotify=true
		Categories=TextEditor;Development;Utility;
		MimeType=text/plain;
		' | sudo tee -a  /usr/share/applications/sublime-text.desktop  > /dev/null 
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
		MimeType=text/plain;sudo npm install -g @vue/cli-init 
		' | sudo tee -a  /usr/share/applications/code.desktop  > /dev/null 

		cd
	fi

	################# LAMPP #################################################
	if [ "$Lampp" == "y" ]; then
		echo "[ LAMPP ]"
		echo ""
		
		echo "Database : MySql (s) ou MariaDB (m) :"
		read myDatabase

		if [ $myDatabase == 's' ]; then
			## install mysql
			wget http://repo.mysql.com/mysql-apt-config_0.8.13-1_all.deb
			sudo dpkg -i mysql-apt-config_0.8.13-1_all.deb
			sudo apt update -y

			sudo apt install mysql-server python-mysqldb -y

		elif [ $myDatabase == 'm' ]; then
			## install mariadb
			echo "Veuillez entrer le mot de passe root SQL que vous souhaitez utilisez!"
			read passwd

			export DEBIAN_FRONTEND="noninteractive"
			sudo debconf-set-selections <<< 'maria-db mysql-server/root_password password PASSWD'
			sudo debconf-set-selections <<< 'maria-db mysql-server/root_password_again password PASSWD'

			sudo apt install mariadb-server python-mysqldb -y
			
			# set password to the root user and grant privileges + automating security sql
			Q0="USE mysql;"
			Q1="UPDATE user SET plugin='' WHERE User='root';"
			Q2="FLUSH PRIVILEGES;"

			Q3="GRANT ALL PRIVILEGES on *.* to 'root'@'localhost' IDENTIFIED BY '$passwd' WITH GRANT OPTION;"
			Q4="FLUSH PRIVILEGES;"

			Q5="DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
			Q6="DELETE FROM mysql.user WHERE User='';"
			Q7="FLUSH PRIVILEGES;"

			SQL="${Q0}${Q1}${Q2}${Q3}${Q4}${Q5}${Q6}${Q7}"

			sudo mysql -u root -pPASSWD -e "$SQL"
			sudo systemctl restart mariadb

		else
			echo 'Aucun gestionnaire de base de donnée choisi !'

		fi

		################# Apache #################################################
		sudo apt install apache2 apache2-doc -y
		
		sudo rm -rf /etc/apache2/sites-available/000-default.conf
		
		echo '
		NameVirtualHost *
		<VirtualHost *>
			ServerAdmin webmaster@localhost

			DocumentRoot /var/www/
			<Directory />
				Options FollowSymLinks
				AllowOverride None
			</Directory>
			<Directory /var/www/>
				Options Indexes FollowSymLinks MultiViews
				AllowOverride None
				Order allow,deny
				allow from all
			</Directory>

			ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
			<Directory "/usr/lib/cgi-bin">
				AllowOverride None
				Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
				Order allow,deny
				Allow from all
			</Directory>

			ErrorLog /var/log/apache2/error.log

			# Possible values include: debug, info, notice, warn, error, crit,
			# alert, emerg.
			LogLevel warn

			CustomLog /var/log/apache2/access.log combined
			ServerSignature On

		    Alias /doc/ "/usr/share/doc/"
		    <Directory "/usr/share/doc/">
			Options Indexes MultiViews FollowSymLinks
			AllowOverride None
			Order deny,allow
			Deny from all
			Allow from 127.0.0.0/255.0.0.0 ::1/128
		    </Directory>
		</VirtualHost>
		' | sudo tee -a  /etc/apache2/sites-available/000-default.conf  > /dev/null 

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


	fi

	################# WORDPRESS  #####################################################

	if [ "$wordpress" == "y" ]; then
		cd $DIR/wp/
		sudo chmod +x wordpress.sh
		./wordpress.sh

	fi
	
	################# SYMFONY  #####################################################
	
	wget https://get.symfony.com/cli/installer -O - | bash
	sudo mv /home/$(whoami)/.symfony/bin/symfony /usr/local/bin/symfony
	
	################# VUEJS  #####################################################
	
	sudo npm install -g @vue/cli-init 

	################# REACTJS  #####################################################
	
	sudo npm install --global create-react-app

	################# REACTNATIVE  #####################################################

	sudo npm install -g expo-cli
	
	mkdir ~/labs
	mkdir ~/labs/ReactJS
	mkdir ~/labs/ReactNat
	mkdir ~/labs/Symfony 
	
	# S'ajouter au groupe www-data
	sudo usermod -a -G www-data $(whoami)

	# Associer le groupe www-data au dossier /var/www
	sudo chgrp -R www-data /var/www/

	# Donne les droits d'écriture a l'utilisateur
	# sudo chown $(whoami):www-data /var/www -R
	sudo chmod -R 777 /var/www/

	# Créer un lien s'imbolique
	sudo ln -s /var/www ~/www  > /dev/null

	sudo a2ensite phpmyadmin.conf
	sudo systemctl restart apache2
	sudo systemctl restart mysql
	

} # fin de devBox

remove() {
	echo "Veuillez entrer le mot de passe utilisateur root MySQL! "
	read -s rootpasswd

	echo "Un petit instant sauvegarde de vos bases de données"

	DB_USER="root"
	DB_PASS=${rootpasswd}
	DB_HOST="localhost"
	OUTDIR=`date +%Y-%m-%d/%H:%M:%S`
	mkdir -p ~/$OUTDIR

	# récupération de la liste des bases
	DATABASES=`MYSQL_PWD=$DB_PASS mysql -u $DB_USER -e "SHOW DATABASES;" | tr -d "| " | grep -v -e Database -e _schema -e mysql`
	
	# boucle sur les bases pour les dumper
	for DB_NAME in $DATABASES; do
		MYSQL_PWD=$DB_PASS mysqldump -u $DB_USER --single-transaction --skip-lock-tables $DB_NAME -h $DB_HOST > ~/$OUTDIR/$DB_NAME.sql
	done

	# boucle sur les bases pour compresser les fichiers
	for DB_NAME in $DATABASES; do
		gzip ~/$OUTDIR/$DB_NAME.sql
	done

	# test si Mysql ou mariadb est installé
	MySql=$(dpkg -l | egrep "mysql-server" 2> /dev/null || echo '')
	MariaDB=$(dpkg -l | egrep "mariadb-server" 2> /dev/null || echo '')

	if [ -n "$MySql" ]; then
		sudo apt purge mysql-server*

		    
	elif [ -n "$MariaDB" ]; then
		sudo apt purge mariadb-server*
			
		    
	else
		echo "Aucune database installer"
		   
	fi

	# test si apache2 est installé
	Apache2=$(dpkg -l | egrep "apache2" 2> /dev/null || echo '')

	if [ -n "$Apache2" ]; then
		sudo apt purge apache2*
		    
	else
		echo "Aucun Server installer"; 
				   
	fi

	sudo snap remove code android-studio atom sublime-text -y
	sudo apt purge php\* npm\* nodejs\* filezilla\* gimp\* composer\* snapd\* -y

	sudo apt autoremove 
	sudo apt autoclean 


	sudo rm -rf /opt/phpMyAdmin
	sudo rm -rf /snap
	sudo rm -rf /usr/share/applications/code.desktop
	sudo rm -rf /usr/share/applications/android-studio.desktop
	sudo rm -rf /usr/share/applications/sublime-text.desktop
	sudo rm -rf /usr/share/applications/atom.desktop
	sudo rm -rf /etc/apache2
	sudo rm -rf /etc/mysql/ /var/lib/mysql/ /var/log/mysql
	sudo rm -rf /var/www
	sudo rm -rf ~/www

	sudo apt clean all 
}

help_() {

	echo "Bonjour et Bienvenu sur devBox"
	echo ""
	echo ""
	echo "[ ./devBox --install ]"
	echo ""
	echo "	Installation selon votre choix d'une listes d'outils indispensable au dev
	
					- LAMPP [ Apache2 + MySql ou MariaDB + PhpMyAdmin]
					- Atom
					- Visual Studio Code
					- Sublime Text 3
					- Android Studio
					- Wordpress 
	
					... 

	Le systemes installera des packets tout aussi indispensable comme :
					- npm 
					- nodejs 
					- filezilla 
					- gimp 
					- composer 
					
					...
			
	D'autres suivrons


	A la fin de l'installation :

					[ APACHE2 ]
					- apache2 => localhost
					=> dossier /var/www 'lien symbolique dans ~/www'

					[ PHPMYADMIN ]
					- PhpMyAdmin => localhost:9000

					[ WORDPRESS ] [ .zshrc ]
					- Wordpress => ~/www/nom_de_votre_site

					# Install new wordpress and database .zshrc
					- alias => wordpress


					[ SYMFONY ] [ .zshrc ]
					- Symfony : traditional web application => composer create-project symfony/website-skeleton nom_du_projet
					- Symfony : microservice, console application or API: =>  composer create-project symfony/skeleton nom_du_projet
					- Symfony : run server =>  symfony server:start 
					
					# Install new symfony project Web .zshrc
					- alias => sy-web

					# Install new symfony project Api .zshrc
					- alias => sy-api

					# Run symfony project .zshrc
					- alias => sy-run
					"



	echo ""
	echo ""
	echo " [ ./devBox --remove ]"
	echo ""
	echo "	Suppression de devBox"
	echo ""
	echo ""
}

########################################################################
case "$1" in
    --install)
        devBox
        ;;
    --remove)
        remove
        ;;
    --help)
        help_
        ;;

    *) echo "[ Oups saisir sur votre terminal ./devBox --help ]"; 
esac
########################################################################
