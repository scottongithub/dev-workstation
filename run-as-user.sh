#!/bin/bash

. ./us-dev-ws.conf

if [[ $create_gpg_key == "yes" ]]; then
  cat >"$HOME/gpg_conf" <<EOF
%echo Generating a basic OpenPGP key
Key-Type: default
Subkey-Type: default
Name-Real: $fullname
Name-Comment: Created by us-dev-ws.sh
Name-Email: $email
%ask-passphrase
# Do a commit here, so that we can later print "done" :-)
%commit
%echo done
EOF

  gpg --batch --generate-key "$HOME/gpg_conf"
  gpg --send-keys --keyserver keyserver.ubuntu.com $(gpg --list-keys --with-colons $email | awk -F: '/^pub:/ { print $5 }')
  rm -r "$HOME/gpg_conf"
fi


if [[ $create_ssh_key == "yes" ]]; then
  ssh-keygen -t rsa -C "$fullname on $(hostname)"
fi

echo "export DEBFULLNAME=\"$fullname\"" >> $bashrc
echo "export DEBEMAIL=\"$email\"" >> $bashrc
source "$bashrc"

pbuilder-dist $ubuntu_release create

if [[ $import_app_configs == "yes" ]]; then
# Copy contents of source directory recursively, omitting rdiff's backup data of the archive
  rsync -rva --progress --exclude "rdiff-backup-data" "$app_configs_source/" "$HOME/"
fi

if [[ ! -z ${autostart_apps+x} ]]; then
  if [ ! -d "$HOME/.config/autostart" ]; then
       mkdir "$HOME/.config/autostart";
  fi
  for app in $autostart_apps; do
    sudo -u $user cat >"$HOME/.config/autostart/$app.desktop" <<EOF
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

exit 0
