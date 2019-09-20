#!/bin/bash -u
 
#Description: Ce script requiert feh sur votre machine, il changera votre fond d'écran openbox (ou autre) automatiquement toutes les 400 secondes
#Author: Millien Marc
#Date: 2 mars 2008
 
#On vérifie l'existence du répertoire Images/Fonds
if [ -d ~/wallpaper/ ] ; then
  cd ~/wallpaper/ && find . -type f -name "*.png" -exec convert {} -strip {} \; 
  #On compte le nombre de fichiers
  _fics=`ls | grep -E "*.(png|jpg|jpeg)" | wc -l` 2> /dev/null
 
  #S'il y a plus d'un fichier c'est parti
  if [ ${_fics} -gt 0 ] ; then
 
   #On vérifie que le script ne tourne pas déjà
   _ps=`ps aux` 2> /dev/null
   _pid=`echo "${_ps}" | grep $0 | tr -s [:space:] | cut -d' ' -f2` 2> /dev/null
   _lines=`echo "${_pid}" | wc -w` 2> /dev/null
 
   if [ ${_lines} -gt 1 ]; then
    _pid=`echo ${_pid} | cut -d' ' -f1` 2> /dev/null
    kill ${_pid} 2> /dev/null
   fi
 
   #Boucle de fonctionnement
   while true; do
 
    #On affiche le fichier
    sleep 5
     feh --randomize --bg-fill ~/wallpaper/*
    sleep 10
   done
  else
   echo "Veuillez placer des fichiers images dans le répertoire ~/wallpapers/  !"
  fi
else
  echo "Veuillez créer le répertoire ~/wallpapers/  et y placer vos fonds d'écran !"
fi