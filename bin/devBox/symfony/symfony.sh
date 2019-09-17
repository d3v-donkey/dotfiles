#!/bin/bash

wget https://get.symfony.com/cli/installer -O - | bash

sudo mv /home/$(whoami)/.symfony/bin/symfony /usr/local/bin/symfony
