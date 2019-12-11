#!/bin/bash


# https://www.hackingtutorials.org/metasploit-tutorials/setup-metasploitable-3-windows-10/

sudo apt dist-upgrade

cd /tmp 

# Installing Vagrant
wget https://releases.hashicorp.com/vagrant/2.1.2/vagrant_2.1.2_x86_64.deb 
sudo dpkg -i vagrant_2.1.2_x86_64.deb

# Installing Packer
wget https://releases.hashicorp.com/packer/1.2.4/packer_1.2.4_linux_amd64.zip
unzip packer_1.2.4_linux_amd64.zip
sudo mv packer /usr/local/bin/packer
sudo rm /usr/local/bin/packer

vagrant plugin install vagrant-reload


cd Downloads && git clone https://github.com/rapid7/metasploitable3.git

# packer build windows_2008_r2.json
# vagrant box add ../builds/windows_2008_r2_virtualbox_0.1.0.box
# vagrant up
