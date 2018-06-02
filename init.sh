#!/bin/bash

# Ensure uid is root
if (( $EUID != 0 )); then
    echo " [!]This script must be run as root" 1>&2
    sudo su
fi

apt-get update -y -q && apt-get upgrade -y -q
apt-get install python -y -q

#oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sed -i 's/robbyrussell/fishy/g' ~/.zshrc

# Powershell
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl -o /etc/apt/sources.list.d/microsoft.list https://packages.microsoft.com/config/ubuntu/14.04/prod.list
curl -o /etc/apt/sources.list.d/microsoft.list https://packages.microsoft.com/config/ubuntu/16.04/prod.list
curl -o /etc/apt/sources.list.d/microsoft.list https://packages.microsoft.com/config/ubuntu/17.04/prod.list
apt-get update && apt-get install -y -q powershell

# go
apt-get install golang
git clone https://github.com/OJ/gobuster.git /opt/gobuster
echo "export GOPATH=$HOME/go" >> ~/.zshrc
echo "export PATH=$PATH:$GOROOT/bin:$GOPATH/bin" >> ~/.zshrc
cd /opt/gobuster
go get && go build
go install

# TrustedSec
## PTH
git clone https://github.com/trustedsec/ptf /opt/ptf
sed -i 's/pentest/jumpbox/g' config/ptf.config
cd /opt/ptf && ./ptf --update-all -y

## SET
apt-get --force-yes -y install git apache2 python-requests libapache2-mod-php \
  python-pymssql build-essential python-pexpect python-pefile python-crypto python-openssl
git clone https://github.com/trustedsec/social-engineer-toolkit/ /opt/set
cd /opt/set
pyhon setup.py install

if [ "$1" != "lite" ]; then
# Powershell magic
git clone https://github.com/samratashok/nishang.git /opt/nishang
git clone https://github.com/EmpireProject/Empire.git /opt/Empire
cd /opt/Empire && ./setup/install.sh

# C2
git clone https://github.com/nettitude/PoshC2.git /opt/PoshC2

# Merlin - HTTP C2

mkdir /opt/merlin; cd /opt/merlin
wget https://github.com/Ne0nd0g/merlin/releases/download/v0.1.4/merlinServer-Linux-x64-v0.1.4.7z
7z x merlinServer-Linux-x64-v0.1.4.7z -pmerlin
rm merlinServer-Linux-x64-v0.1.4.7z

# dnscat2
apt-get install -y -q gcc make libpcap-dev
git clone https://github.com/iagox86/dnscat2.git /opt/dnscat2
cd /opt/dnscat2/client && make

# masscan
git clone https://github.com/robertdavidgraham/masscan /opt/masscan
cd /opt/masscan
make

# pupy shell
git clone https://github.com/n1nj4sec/pupy.git /opt/pupyshell
cd /opt/pupyshell
git submodule init
git submodule update
pip install -r pupy/requirements.txt
wget https://github.com/n1nj4sec/pupy/releases/download/latest/payload_templates.txz
tar xvf payload_templates.txz && mv payload_templates/* pupy/payload_templates/ && rm payload_templates.txz && rm -r payload_templates


# Wordlists
git clone https://github.com/danielmiessler/SecLists.git /usr/share/wordlists/SecLists
git clone https://github.com/berzerk0/Probable-Wordlists.git /usr/share/wordlists/Probable

fi
