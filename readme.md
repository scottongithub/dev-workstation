# Overview
Bash script that sets up a development workstation on Ubuntu. The following options can be configured in the config file:

- Installed PPAs
- Installed applications
- Autostarting applications (uses .desktop files with XFCE-specific settings)
- Create gpg keys and send them to Ubuntu's key server
- Create ssh keys
- Environment variables DEBFULLNAME and DEBEMAIL are created/set/added to ~/.bashrc
- Chroot environment set up by pbuilder-create_pbuilder_dist
- Application setting import from previously exported config files (using config-backup)

# Prerequisites
Uses apt plus the repositories added in the .conf file. Tested on new install of Ubuntu 19.04/xfce

# Usage
Copy the folder locally, edit the config file, run 'run-as-root' as root, then run 'run-as-user' as user

# License
GPLv3
