#!/bin/bash

echo $1 

mkdir -p /root/.config/code-server
touch /root/.config/code-server/config.yaml
printf "bind-addr: 0.0.0.0:8080 \n\
auth: none \n\
password: 1234 \n \
cert: false \n" > /root/.config/code-server/config.yaml
mkdir -p development
cd development
code-server --install-extension github.github-vscode-theme \ 
     --install-extension ms-python.python \
     --install-extension pkief.material-icon-theme \
     --install-extension ms-python.vscode-pylance \
     --install-extension ms-toolsai.jupyter \
     --install-extension esbenp.prettier-vscode \
     --install-extension formulahendry.code-runner \
     --install-extension eamodio.gitlens \
     --install-extension donjayamanne.python-environment-manager \
     --install-extension GitHub.vscode-pull-request-github \ &

git clone https://github.com/br3ndonland/template-python.git /root/development/project 
printf '{  
    "workbench.colorTheme": "GitHub Dark",
    "workbench.iconTheme": "material-icon-theme"
    }' > /root/.local/share/code-server/User/settings.json

code-server /root/development/project --auth none
