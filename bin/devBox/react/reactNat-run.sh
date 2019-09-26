#!/bin/bash

new_projet() {
    echo "Veuillez Choisir le nom de votre projet"
    read name

    cd ~/labs/ReactNat && sudo expo init $name
}


########################################################################
case "$1" in
    --new-projet)
        new_projet
        ;;
    --help)
        help_
        ;;

    *) echo "[ Oups saisir sur votre terminal ./devBox --help ]"; 
esac
########################################################################
