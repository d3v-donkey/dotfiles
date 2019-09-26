#!/bin/bash

new_projet() {
    echo "Veuillez Choisir le nom de votre projet"
    read name

    # cd ~/www/html/VueJS && vue init webpack $name
    cd ~/labs/VueJS && vue create $name
    cd $name && npm install
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

