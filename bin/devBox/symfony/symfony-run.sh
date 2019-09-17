#!/bin/bash

# Create new project Web witch symfony
new_projet-web() {
    echo "Nom de votre projet"
    read name

    #cd ~/www/html && symfony new --full $name
    cd ~/www/html && composer create-project symfony/website-skeleton $name

}

# Create new project Api witch symfony
new_projet-api() {
    echo "Nom de votre projet"
    read name

    #cd ~/www/html && symfony new $name
    cd ~/www/html && composer create-project symfony/skeleton $name

}

# Create new project witch symfony
server_run() {
    symfony server:start
}









########################################################################
case "$1" in
    --new_projet-web)
        new_projet-web
        ;;
    --new_projet-api)
        new_projet-api
        ;;
    --server_run)
        server_run
        ;;
    --help)
        help_
        ;;

    *) echo "[ Oups saisir sur votre terminal ./devBox --help ]"; 
esac
########################################################################