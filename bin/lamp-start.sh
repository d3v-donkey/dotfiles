#!/bin/bash


################# START LAMP ######################################
lamp_start() {

	MySql=$(dpkg -l | egrep "mysql-server" 2> /dev/null || echo '')
	MariaDB=$(dpkg -l | egrep "mariadb-server" 2> /dev/null || echo '')

	if [ -n "$MySql" ]; then
	    #sudo systemctl start mysql
		echo "test mysql"
	    
	elif [ -n "$MariaDB" ]; then
	    #sudo systemctl start mariadb
		echo "test maria"
	    
	else

		echo $password | sudo -S apt update
	   
	fi

	Apache2=$(dpkg -l | egrep "apache2" 2> /dev/null || echo '')

	if [ -n "$Apache2" ]; then
	    #sudo systemctl start apache2
		echo "test apache2"
	    
	else
	    #echo "pas de serveur"
		echo "test not"
	   
	fi
}

################# STOP LAMP ######################################
lamp_stop() {

	MySql=$(dpkg -l | egrep "mysql-server" 2> /dev/null || echo '')
	MariaDB=$(dpkg -l | egrep "mariadb-server" 2> /dev/null || echo '')

	if [ -n "$MySql" ]; then
	    sudo systemctl stop mysql
	    
	elif [ -n "$MariaDB" ]; then
	    sudo systemctl stop mariadb
	    
	else
	    echo "pas de database"
	   
	fi

	Apache2=$(dpkg -l | egrep "apache2" 2> /dev/null || echo '')

	if [ -n "$Apache2" ]; then
	    sudo systemctl stop apache2
	    
	else
	    echo "pas de serveur"
	   
	fi
}

###################### PASSWORD SUDO ##############################
password=$(zenity --password --text "Saisir Votre Password Sudo")
if [ -n "$password" ]; then
   echo "Password noter"
else
   zenity --text "Vous devez Saisir Votre Password !"
fi




####################### MAIN ###################################

zenity --list   --title="Choose script" --column="Script" --column="Description" "a.sh" "chaise longue" "b.sh" "moineau"

