#!/bin/bash

new_projet() {
    echo "Veuillez Choisir le nom de votre projet"
    read name

    cd ~/www/html && sudo vue init webpack $name

    cd $name && npm install
}

