#!/bin/bash

##########################################################################
################### DevBox stack installer for Debian ####################
########################################################################## 


sudo apt-get update -y


################# PACKAGES #############################################
sudo apt install npm snapd apt-transport-https nodejs -y


################# ATOM #################################################
wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -

echo "
deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main
" | sudo tee -a  /etc/apt/sources.list.d/atom.list  > /dev/null 

sudo apt-get update -y
sudo apt-get install atom -y

cd


################# SUBLIME-TEXT #########################################
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -

echo "
deb https://download.sublimetext.com/ apt/stable/
" | sudo tee -a  /etc/apt/sources.list.d/sublime-text.list > /dev/null 

sudo apt-get update -y
sudo apt-get install sublime-text -y

cd

################# ANDROID-STUDIO #######################################
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

################# LAMP #################################################
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








