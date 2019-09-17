#!/bin/bash

### Jdownloader2 ###

sudo mkdir /opt/JDownloader2
cd /opt/JDownloader2 && sudo git clone https://github.com/d3v-donkey/jdownloader.git
cd jdownloader && sudo chmod +x JD2Setup_x64.sh && ./JD2Setup_x64.sh
