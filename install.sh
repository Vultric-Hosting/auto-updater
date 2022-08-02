#!/bin/bash

quit() {
  echo ""
  exit
}

clear
echo ""
echo "Vultric Hosting Auto Updater"
echo "Developed by Vultric Hosting"
echo ""

if [ $EUID -ne 0 ]; then
  echo "Please run the command with sudo."
  quit
fi

if [ ! command -v apt-get &> /dev/null ]; then
  echo "This script only works on Debian-based systems."
  quit
fi

if [ "$1" = '--help' ]; then
 echo "--help - Shows this screen"
 echo "--no-dependencies - Skips installing required packages"
 quit
fi

if [ "$1" = '--no-dependencies' ] || [ "$2" = '--no-dependencies' ]; then
 echo "Skipping dependency install."
else
  echo "Installing dependencies.."
  apt-get update
  apt-get install -y curl jq
fi

echo "Detecting existing installation.."
if [ -d /srv/updater ]; then
    echo "Auto update script already installed."
    quit
fi
if [ -d /var/www/pterodactyl ]; then
    echo "Pterodactyl Panel Installation detected."
    if [ ! -d /srv/updater ]; then
      echo "Creating folder for scripts.."
      mkdir /srv/updater
    fi
    echo "Downloading Panel update script.."
    curl -o /srv/updater/panel.sh https://raw.githubusercontent.com/Vultric-Hosting/auto-updater/develop/panel.sh
    echo "Adding Panel update script to crontab.."
    crontab -l | {
      cat
      echo "5 1 */1 * * sh /srv/updater/panel.sh >> /dev/null 2>&1"
    } | crontab -
fi
if [ -d /var/lib/pterodactyl ]; then
    echo "Pterodactyl Wings Installation detected."
    if [ ! -d /srv/updater ]; then
      echo "Creating folder for scripts."
      mkdir /srv/updater
    fi
    echo "Downloading Wings update script.."
    curl -o /srv/updater/wings.sh https://raw.githubusercontent.com/Vultric-Hosting/auto-updater/develop/wings.sh
    echo "Adding Wings update script to crontab.."
    crontab -l | {
      cat
      echo "5 1 */1 * * sh /srv/updater/wings.sh >> /dev/null 2>&1"
    } | crontab -
fi
echo "Downloading main update script.."
curl -o /srv/updater/update.sh https://raw.githubusercontent.com/Vultric-Hosting/auto-updater/develop/update.sh
echo "Adding main update script to crontab.."
crontab -l | {
  cat
  echo "0 1 */1 * * sh /srv/updater/update.sh >> /dev/null 2>&1"
} | crontab -
echo "Installation complete."
quit
