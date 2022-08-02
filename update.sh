#!/bin/sh

if [ -d /var/www/pterodactyl ]; then
    curl -o /srv/updater/panel.sh https://raw.githubusercontent.com/Vultric-Hosting/auto-updater/develop/panel.sh
fi
if [ -d /var/lib/pterodactyl ]; then
    curl -o /srv/updater/wings.sh https://raw.githubusercontent.com/Vultric-Hosting/auto-updater/develop/wings.sh
fi
