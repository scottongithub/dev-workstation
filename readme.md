# Overview
Bash script that sets up a development environment in Ubuntu 19.04. The following options can be toggled/configured in the config file:

- Installed PPAs
- Installed applications
- Autostarting applications (specific to xfce)
- Create gpg keys and send them to Ubuntu's key server
- Create ssh keys
- Environment variables DEBFULLNAME and DEBEMAIL are added to ~/.bashrc
- Chroot environment set up by pbuilder-create_pbuilder_dist
- Application setting import from previously exported config files (using config-backup)

# Prerequisites
Tested on new install of Ubuntu/xfce

# Usage
Copy the folder locally, edit the config file, run 'run-as-root' as root, run 'run-as-user' as user

# License
GPLv3
