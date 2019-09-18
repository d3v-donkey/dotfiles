#!/bin/bash

new_projet() {
    echo "Veuillez Choisir le nom de votre projet"
    read name

    cd ~/www/html && sudo ionic start $name
}

run_projet() {
    sudo ionic serve
}


########################################################################
case "$1" in
    --new-projet)
        new_projet
        ;;
    --run-projet)
        run_projet
        ;;
    --help)
        help_
        ;;

    *) echo "[ Oups saisir sur votre terminal ./devBox --help ]"; 
esac
########################################################################