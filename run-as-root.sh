#!/bin/bash

. ./us-dev-ws.conf

for ppa in $ppas; do
  sudo apt-add-repository -y $ppa
done

sudo apt update -y
sudo apt upgrade -y

for package in $packages; do
  sudo apt-get install -y $package
done

if [[ $install_atom == "yes" ]]; then
  wget -q https://packagecloud.io/AtomEditor/atom/gpgkey -O- | sudo apt-key add -
  sudo add-apt-repository -y "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main"
  sudo apt update -y
  sudo apt install atom -y
fi

exit 0
