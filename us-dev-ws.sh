#!/bin/bash

#Source the config file with a "."
. ~/P_HOME/CODE/US_DEV_WS/us-dev-ws.conf

if [ ! -d $temp_dir ]; then
    mkdir $temp_dir;
fi

cd $working_dir


for ppa in $ppas; do
  sudo apt-add-repository $ppa | tee -a $logfile
done
sudo apt update | tee -a $logfile
sudo apt upgrade | tee -a $logfile


for package in $packages; do
  sudo apt install $package | tee -a $logfile
done

if install_atom=yes; then
  wget -q https://packagecloud.io/AtomEditor/atom/gpgkey -O- | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main"
  sudo apt install atom
fi

if create_gpg_key=yes; then
  cat >"$HOME/gpg_conf" <<EOF
     %echo Generating a basic OpenPGP key
     Key-Type: default
     Subkey-Type: default
     Name-Real: $debfullname
     Name-Comment: Created by us-dev-ws.sh
     Name-Email: $debemail
     %pubring "${debfullname// /_}".pub
     %secring "${debfullname// /_}".sec
     # Please don't change this to put plaintext-passwords here
     %ask-passphrase
     # Do a commit here, so that we can later print "done" :-)
     %commit
     %echo done
EOF
# Long format is used to prevent collisions on bigger systems
  gpg --send-keys --keyserver keyserver.ubuntu.com $(gpg --keyid-format long --list-keys $debemail)
fi

if import_gpg_keys=yes; then
  cp -r $gpg_key_location "$HOME/.gnupg"
fi

if create_ssh_key=yes; then
  ssh-keygen -t rsa | tee -a $logfile
fi

if import_ssh_keys=yes; then
  cp -r $ssh_key_location "$HOME/.ssh"
fi

pbuilder-dist $ubuntu_release create


echo "export DEBFULLNAME=\"$debfullname\"" >> $bashrc
echo "export DEBEMAIL=\"$debemail\"" >> $bashrc


for backup_dir in $BackupDirs; do

Destination="${backup_dir}/${BackupName}_$(hostname)"

  if [ ! -d $Destination ]; then
      mkdir $Destination;
  fi

  rdiff-backup -v9 $TempDir $Destination

done

rm -rf $TempDir
