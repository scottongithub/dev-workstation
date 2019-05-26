#!/bin/bash

. ~/P_HOME/CODE/US_DEV_WS/us-dev-ws.conf

# if [ ! -d $temp_dir ]; then
#     mkdir $temp_dir;
# fi
#
# cd $working_dir

for ppa in $ppas; do
  sudo apt-add-repository $ppa
done

sudo apt update
sudo apt upgrade

for package in $packages; do
  sudo apt-get install -y $package
done

if [[ $install_atom == "yes" ]]; then
  wget -q https://packagecloud.io/AtomEditor/atom/gpgkey -O- | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main"
  sudo apt update
  sudo apt install atom
fi

if [[ $create_gpg_key == "yes" ]]; then
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
# Long format is used to prevent collisions on bigger systems - probably overkill
  gpg --send-keys --keyserver keyserver.ubuntu.com $(gpg --keyid-format long --list-keys $debemail)
fi

if [[ $import_gpg_keys == "yes" ]]; then
# Copy recursively, interactively (prompt before replacing)
  cp -ri $gpg_key_source "$HOME"
fi

if [[ $create_ssh_key == "yes" ]]; then
  ssh-keygen -t rsa -C "$fullname on $(hostname)"
fi

if [[ $import_ssh_keys == "yes" ]]; then
# Copy recursively, interactively (prompt before replacing)
  cp -ri $ssh_key_source "$HOME"
fi

echo "export DEBFULLNAME=\"$fullname\"" >> $bashrc
echo "export DEBEMAIL=\"$email\"" >> $bashrc
source $bashrc

pbuilder-dist $ubuntu_release create

if [[ $import_app_configs == "yes" ]]; then
# Copy contents of source directory recursively, omitting rdiff's backup data of the archive
  rsync -rva --progress --exclude "rdiff-backup-data" $app_configs_source. $HOME
fi

if [[ ! -z ${autostart_apps+x} ]]; then
  for app in $autostart_apps; do
    cat >"$HOME/.config/autostart/$app.desk" <<EOF
      [Desktop Entry]
      Encoding=UTF-8
      Type=Application
      Name=$app
      Comment=Created by ws-dev-ws.sh
      Exec=$app
      OnlyShowIn=XFCE;
      StartupNotify=false
      Terminal=false
      Hidden=false
EOF
  done
fi

#rm -rf $TempDir
