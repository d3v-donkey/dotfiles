#!/bin/bash

echo "


--------------------------------------- 
[ Symfony Web new project ] => 

cd ~/labs/Symfony && composer create-project symfony/website-skeleton nom_du_projet
cd ~/labs/Symfony/nom_du_projet && sudo symfony server:start 

---------------------------------------
[ Symfony Api new project] => 

cd ~/labs/Symfony && composer create-project symfony/skeleton nom_du_projet
cd ~/labs/Symfony/nom_du_projet && sudo symfony server:start 

--------------------------------------- 

"