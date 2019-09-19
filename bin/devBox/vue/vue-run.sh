#!/bin/bash

new_projet() {
    echo "Veuillez Choisir le nom de votre projet"
    read name

    cd ~/www/html && sudo vue init webpack $name

    cd $name && sudo npm install
}

run_projet() {
    sudo npm run dev
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

