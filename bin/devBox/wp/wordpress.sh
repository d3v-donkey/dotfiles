#!/bin/bash

clear

charset="utf8mb4"

echo ""
echo "[ WORDPRESS ]"
echo ""

echo "Afin d'installer Wordpress entrez le nom de la base de données MySQL!  [ Exemple: wp_nomDeVotreSite ]"

echo "[ Attention au caractére utilisé : charset="utf8mb4" ]"
read dbname

echo "Souhaitez-vous créer un nouvel utilisateur associer à la base de données" $dbname "[ 'y' ou 'n' ] "
read user

echo "Veuillez entrer votre mot de passe root MySQL!"
read rootpasswd

if [ $user == "y" ]; then
	echo "Veuillez entrer le NOM du nouvel utilisateur de la base de données MySQL! (exemple: utilisateur1)"
	read username

	echo "Veuillez entrer le MOT DE PASSE du nouvel utilisateur de la base de données" $dbname
	read userpass
	
else
	echo "ok"
fi

echo "Création de la base de données MySQL ..."
MYSQL_PWD=${rootpasswd} mysql -u "root" -e "CREATE DATABASE ${dbname} /*\!40100 DEFAULT CHARACTER SET ${charset} */;"
#mysql -uroot -p${rootpasswd} -e "CREATE DATABASE ${dbname} /*\!40100 DEFAULT CHARACTER SET ${charset} */;"
echo "Base de données créée avec succès!"

echo "Affichage des bases de données existantes ..."
MYSQL_PWD=${rootpasswd} mysql -u "root" -e "SHOW DATABASES;"
#mysql -uroot -p${rootpasswd} -e "show databases;"
echo ""

if [ $user == "y" ]; then
	echo "Création d'un nouvel utilisateur ..."
	MYSQL_PWD=${rootpasswd} mysql -u "root" -e "CREATE USER ${username}@localhost IDENTIFIED BY '${userpass}';"
	#mysql -uroot -p${rootpasswd} -e "CREATE USER ${username}@localhost IDENTIFIED BY '${userpass}';"
	echo "Utilisateur créé avec succès!"
	echo ""

	echo "Granting ALL privileges on ${dbname} to ${username}!"
	MYSQL_PWD=${rootpasswd} mysql -u "root" -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${username}'@'localhost';"
	#mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${username}'@'localhost';"
	MYSQL_PWD=${rootpasswd} mysql -u "root" -e "FLUSH PRIVILEGES;"
	#mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
	
	echo "Succèes :)"
	
else
	echo "ok"
	
fi


		

echo "Installation de WordPress"
cd /tmp/ && wget -c https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz

sudo rm -rf latest.tar.gz

sudo mv wordpress/ /var/www/$dbname
sudo chown -R www-data:www-data /var/www/$dbname/
sudo chmod 755 -R /var/www/$dbname/

echo "
<VirtualHost *:80>
	ServerAdmin admin@$dbname.com
	DocumentRoot /var/www/$dbname
	ServerName $dbname.com

	<Directory /var/www/$dbname>
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
