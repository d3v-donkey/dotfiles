#!/bin/bash
#
# Created By: riesc0 
#

clear
if [ "$EUID" -ne 0 ]; then
	echo "Has de ser root"
	exit 
fi 

echo -e "Selecciona la interfaz de la tarjeta alfa que quieres aumentar la potencia\n"
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
read -p "Opcion: " opc

if [[ $opc -gt 0 ]] && [[ $opc -le $i ]]; then
	index=$(($opc - 1))
	ifconfig ${ifaces[$index]} down
	iw reg set BZ
	iwconfig ${ifaces[$index]} txpower 30
	ifconfig ${ifaces[$index]} up
	echo ${ifaces[$index]}
fi
