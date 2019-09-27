#!/bin/bash

#==============================================================================================================
#
# Auteur  : Alexandre Maury
# License : Distributed under the terms of GNU GPL version 2 or later
#
# GitHub : https://github.com/d3v-donkey
#==============================================================================================================

# Couleurs Bash

#    30m : noir
#    31m : rouge
#    32m : vert
#    33m : jaune
#    34m : bleu
#    35m : rose
#    36m : cyan
#    37m : gris

#==============================================================================================================
clear
echo -e  "\e[32m                                                  _____    ____   __      __    _______   ______              __  __ ";
echo -e  "\e[32m                                                 |  __ \  |___ \  \ \    / /   |__   __| |  ____|     /\     |  \/  |";
echo -e  "\e[32m                                                 | |  | |   __) |  \ \  / /       | |    | |__       /  \    | \  / |";
echo -e  "\e[32m                                                 | |  | |  |__ <    \ \/ /        | |    |  __|     / /\ \   | |\/| |";
echo -e  "\e[32m                                                 | |__| |  ___) |    \  /         | |    | |____   / ____ \  | |  | |";
echo -e  "\e[32m                                                 |_____/  |____/      \/          |_|    |______| /_/    \_\ |_|  |_|";

echo ""

########################################################################
EUID_0() {
########################################################################
    if [[ $EUID = 0 ]]; then
        echo -e  "\e[33m==================================================================================================================[Droits sudo accorder ...]=====";

    else
	    echo -e  "\e[31m=============================================================================================[Veuillez lancer le scripts en root (sudo) ...]=====";
        exit 1
    fi
}

backup_dir="/opt/anon/backups"

tor_user="tor"
dns_port="9061"
trans_port="9051"
tor_virtual_network="10.66.0.0/255.255.0.0"


########################################################################
main() {
########################################################################
systemctl stop tor.service
systemctl stop resolvconf 
systemctl stop NetworkManager.service
sleep 5

echo "==>" "Sauvegarde original iptables"
if ! cp -vf /etc/iptables/iptables.rules $backup_dir/iptables.rules; then
    echo "[ failed ] copie"
    exit 1
fi
sleep 3

echo "==>" "Sauvegarde original resolv.conf"
if ! cp -vf /etc/resolv.conf $backup_dir/resolv.conf; then
    echo "[ failed ] copie"
    exit 1
fi
sleep 3

echo "==>" "Sauvegarde original /etc/tor/torrc"
if ! cp -vf /etc/tor/torrc $backup_dir/torrc; then
    echo "[ failed ] copie"
    exit 1
fi
sleep 3

echo "==>" "Copie /etc/tor/torrc"
cat > /etc/tor/torrc << 'EOF'
VirtualAddrNetwork 10.66.0.0/255.255.0.0
TransPort 9051
DNSPort 9061
AutomapHostsOnResolve 1
EOF
sleep 5

echo "==>" "New resolv.conf"
cat > /etc/resolv.conf << 'EOF'
nameserver 127.0.0.1
EOF
sleep 5

echo "==>" "Flush iptables + ecriture des nouvelles tables"
for table in nat filter ; do

	target="ACCEPT"
	if [ "$table" = "nat" ] ; then
		target="RETURN"
	fi
	
	#initialize output chain
	iptables -t $table -F OUTPUT

	#ignore already established connections
	iptables -t $table -A OUTPUT -m state --state ESTABLISHED -j $target
	
	#don't send tor traffic through tor again
	iptables -t $table -A OUTPUT -m owner --uid tor  -j $target
	

	#handle dns traffic
	match_dns_port="$dns_port"
	if [ "$table" = "nat" ] ; then
		target="REDIRECT --to-ports $dns_port"
		match_dns_port=53
	fi
	iptables -t $table -A OUTPUT -p udp --dport $match_dns_port -j $target
	iptables -t $table -A OUTPUT -p tcp --dport $match_dns_port -j $target


	#handle hidden_service traffic
	if [ -n "$tor_virtual_network" ] ; then
		if [ "$table" = "nat" ] ; then
			target="REDIRECT --to-ports $trans_port"
		fi
		iptables -t $table -A OUTPUT -d $tor_virtual_network -p tcp -j $target
	fi


	# don't send local/loopback stuff through tor
	# all dns requests have already been sent to tor
	# so, we don't have to worry about handling that specially
	if [ "$table" = "nat" ] ; then
		target="RETURN"
	fi
	iptables -t $table -A OUTPUT -d 127.0.0.1/8    -j $target
	iptables -t $table -A OUTPUT -d 192.168.0.0/16 -j $target
	iptables -t $table -A OUTPUT -d 172.16.0.0/12  -j $target
	iptables -t $table -A OUTPUT -d 10.0.0.0/8     -j $target

	#handle tcp traffic
	if [ "$table" = "nat" ] ; then
		target="REDIRECT --to-ports $trans_port"
	fi
	iptables -t $table -A OUTPUT -p tcp -j $target
done

#block non-local udp/icmp traffic
iptables -t filter -A OUTPUT -p udp -j REJECT
iptables -t filter -A OUTPUT -p icmp -j REJECT

echo "==>" "Activation des services"
systemctl start tor.service resolvconf NetworkManager.service
services=$?
sleep 6

if [ "$services" -eq 0 ]; then
    echo "[ ok ]  Activation Services succes"
else
    systemctl restart tor.service iptables NetworkManager.service
    restart_services=$?
    if [ "$restart_services" -eq 0 ]; then
        echo "[ ok ]  restart Services succes"
    else
        echo "[ failed ] restart Services"
        exit 1
    fi
fi
sleep 6

if ! systemctl is-active tor.service; then
    echo "[-] Tor service n'est pas actif..."
    exit 1
fi
sleep 6

if ! torsocks wget -qO- https://check.torproject.org/ | grep -i congratulations; then 
    echo "[ failed ] Tor n'est pas opérationnel"
    exit 1
fi

if ! torsocks curl -s -m 10 ipinfo.io/geo | tr -d '"{}' | sed 's/ //g'; then
    echo "[ failed ] curl: HTTP request"
    exit 1
fi

echo "Activation Terminer..."

echo "==>" "[Ex d'utilisation :]"
echo "torsocks nmap -sT -PN -n -sV -p 80,443,22,21,25,53,445,81 {target} -oX /tmp/repports-{target}.scan"
echo "rapport disponible ==> /tmp/reports-{target}.html"
echo "..."
}

########################################################################
stop() {
########################################################################
EUID_0

echo "==>" "Arrets du Proxy Tor"
systemctl stop tor.service
systemctl stop NetworkManager.service

for table in nat filter ; do
	iptables -t $table -F OUTPUT
done

# Restauration /etc/resolv.conf
echo "Restauration default DNS (resolv.conf)"
rm -v /etc/resolv.conf
cp -vf $backup_dir/resolv.conf /etc/resolv.conf
sleep 1

# Restauration default /etc/tor/torrc
echo "Restauration tor settings"
rm -vf /etc/tor/torrc
cp -vf $backup_dir/torrc /etc/tor/torrc
sleep 1

systemctl start NetworkManager.service

systemctl start NetworkManager.service
sleep 2
}


########################################################################
restart() {
########################################################################
EUID_0

echo "==>" "Restart Tor service et change adresse IP"
systemctl restart tor.service iptables
sleep 4
echo "[ ok ]" "Service anon redémarer"
exit 0
}



########################################################################
case "$1" in
    --start)
        main
        ;;
    --stop)
        stop
        ;;
    --restart)
        restart
        ;;

    *) echo "Options invalid" "[./anon_Install --start]" && exit 1
esac
########################################################################