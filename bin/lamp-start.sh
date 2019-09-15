#!/bin/bash


################# START LAMP ######################################
lamp_start() {

	MySql=$(dpkg -l | egrep "mysql-server" 2> /dev/null || echo '')
	MariaDB=$(dpkg -l | egrep "mariadb-server" 2> /dev/null || echo '')

	if [ -n "$MySql" ]; then
	    echo $password | sudo -S systemctl start mysql

	    
	elif [ -n "$MariaDB" ]; then
	    echo $password | sudo -S systemctl start mariadb
		
	    
	else
	    echo "Aucune database installer"; notify-send "Start Sql Failed"
	   
	fi

	Apache2=$(dpkg -l | egrep "apache2" 2> /dev/null || echo '')

	if [ -n "$Apache2" ]; then
	    echo $password | sudo -S systemctl start apache2
	
	    
	else
	    echo "Aucun Server installer"; notify-send "Start Server Failed"
		
	   
	fi
}

################# STOP LAMP ######################################
lamp_stop() {

	MySql=$(dpkg -l | egrep "mysql-server" 2> /dev/null || echo '')
	MariaDB=$(dpkg -l | egrep "mariadb-server" 2> /dev/null || echo '')

	if [ -n "$MySql" ]; then
	    echo $password | sudo -S systemctl stop mysql
	    
	elif [ -n "$MariaDB" ]; then
	    echo $password | sudo -S systemctl stop mariadb
	    
	else
	    echo "Erreur"; notify-send "Stop Sql Failed"
	   
	fi

	Apache2=$(dpkg -l | egrep "apache2" 2> /dev/null || echo '')

	if [ -n "$Apache2" ]; then
	    echo $password | sudo -S systemctl stop apache2
	    
	else
	    echo "Aucun Server installer"; notify-send "Stop Server Failed"
	   
	fi
}

################# RESTART LAMP ######################################
lamp_restart() {

	MySql=$(dpkg -l | egrep "mysql-server" 2> /dev/null || echo '')
	MariaDB=$(dpkg -l | egrep "mariadb-server" 2> /dev/null || echo '')

	if [ -n "$MySql" ]; then
	    echo $password | sudo -S systemctl restart mysql
	    
	elif [ -n "$MariaDB" ]; then
	    echo $password | sudo -S systemctl restart mariadb
	    
	else
	    echo "Erreur"; notify-send "Restart Sql Failed"
	   
	fi

	Apache2=$(dpkg -l | egrep "apache2" 2> /dev/null || echo '')

	if [ -n "$Apache2" ]; then
	    echo $password | sudo -S systemctl restart apache2
	    
	else
	    echo "Aucun Server installer"; notify-send "Restart Server Failed"
	   
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

choix=$(zenity  --list   --title=" " --column="Lamp" --column="Description" "Start" "Lance les services Apache2 - MySQl ou MariaDB" "Stop" "Stop les services" "Status" "Apercut des services" "Restart" "Redémare les services" --width=550 --height=250)

if [ $choix == "Start" ]; then
	lamp_start

elif [ $choix == "Stop" ]; then
	lamp_stop

elif [ $choix == "Status" ]; then
	lamp_status

elif [ $choix == "Restart" ]; then
	lamp_restart
else
	echo "Choix non valide"

fi



