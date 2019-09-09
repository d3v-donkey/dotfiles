#!/bin/bash

################################################################################################
######################## Install VirtualBox by d3v-donkey ######################################
################################################################################################

wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -

sudo add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian buster contrib"

sudo apt update -y

sudo apt install virtualbox-6.0 -y
