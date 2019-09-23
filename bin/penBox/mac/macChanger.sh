#!/bin/bash
#
# Created By: riesc0 
#

vendor_mac="04:db:56"	  # Apple vendor
vendor_cisco="00:00:0c"	  # Cisco
vendor_toshiba="00:08:0d" # Toshiba
vendor_samsung="f4:9f:54" # Samsung
vendor_dell="d0:67:e5"	  # Dell
vendor=""

clear
if [ "$EUID" -ne 0 ]; then
	echo "Has de ser root"
	exit 
fi 

echo -e "Selecciona vendedor del que quieres suplantar la mac\n"
echo -e "\t 1) Apple"
echo -e "\t 2) Cisco"
echo -e "\t 3) Toshiba"
echo -e "\t 4) Samsung"
echo -e "\t 5) Dell\n"
read -p "Opcion: " opc

if [[ $opc -lt 1 ]] || [[ $opc -gt 5 ]]; then
	echo "Opcion incorrecta"
	exit
else
	case "$opc" in
		1) vendor="$vendor_mac" ;;
		2) vendor="$vendor_cisco" ;;
		3) vendor="$vendor_toshiba" ;;
		4) vendor="$vendor_samsung" ;;
		5) vendor="$vendor_dell" ;;
	esac
fi
clear

echo -e "Selecciona la interfaz a la que quieres cambiar la MAC \n"
i=0
ifaces=()
for opc in `ip -o link show | awk -F': ' '{print $2}' | grep -Fvx -e lo`; do
	ifaces[$i]="$opc"
	((i++))
done

i=1
for item in ${ifaces[*]}; do
	echo -e "\t" $i")" $item
	((i++))
done
echo -e "\t" $i") todas\n" 
read -p "Opcion: " opc

if [[ $opc -gt 0 ]] && [[ $opc -le $i ]]; then
	if [ $opc -eq $i ]; then
		for item in ${ifaces[*]}; do
			mac="$(echo -n $vendor; od -t x1 -An -N 3 /dev/urandom | tr ' ' ':')"
			ifconfig $item down
			ifconfig $item hw ether $mac
			echo $item" - new MAC ("$mac")"
			ifconfig $item up
		done
	else
		index=$(($opc - 1))
		mac="$(echo -n $vendor; od -t x1 -An -N 3 /dev/urandom | tr ' ' ':')"
		ifconfig ${ifaces[$index]} down
		ifconfig ${ifaces[$index]} hw ether $mac
		ifconfig ${ifaces[$index]} up
		echo ${ifaces[$index]}" - new MAC ("$mac")"
	fi
else
	echo "Opcion incorrecta"
fi
