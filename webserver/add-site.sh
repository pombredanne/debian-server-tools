#!/bin/bash

# Apache add new site.
# Not a script but a manual.

exit 0


U=<USER>
D=<DOMAIN>

adduser --disabled-password $U

# add system mail alias for <USER>
cd /etc/courier/aliases
makealiases

# add sudo permissions for real users
cd /etc/sudoers.d/
# set up SSH key
sudo -u $U -i -- ssh-keygen -t rsa
cd /home/$U/.ssh
cp -a id_rsa.pub authorized_keys2
zip --encrypt $U.zip id_rsa*

cd /home/$U/
mkdir public_html && cd public_html
mkdir {session,tmp,server,pagespeed,backup}

# HTTP authentication
htpasswd -c ./htpasswords <USERNAME>
chmod 600 ./htpasswords

# existing WP install
cd /home/$U/

# migrate files NOW

# repair permissions, line ends
find -type f \( -name ".htaccess" -o -name "*.php" -o -name "*.js" -o -name "*.css" \) -exec dos2unix --keepdate \{\} \;
chown -R $U:$U *
find -type f -exec chmod --changes 644 \{\} \;
find -type d -exec chmod --changes 755 \{\} \;
chmod -v 750 public_*
find -name wp-config.php -exec chmod -v 400 \{\} \;
find -name settings.php -exec chmod -v 400 \{\} \;
find -name .htaccess -exec chmod -v 640 \{\} \;

# WordPress wp-config.php
# https://api.wordpress.org/secret-key/1.1/salt/
# WordPress fail2ban

# migrate database NOW

# create WordPress database from wp-config, see: mysql/wp-createdb.sh

# set wp-cli url, debug, user, skip-plugins
e wp-cli.yml

# add own WP user
suwp user create viktor viktor@szepe.net --role=administrator --user_pass=<PASSWORD> --display_name=v

# clean up old data
suwp transient delete-all
suwp w3-total-cache flush
suwp search-replace --dry-run --precise /oldhome/path /home/path

# PHP
cd /etc/php5/fpm/pool.d/
sed "s/@@USER@@/$U/g" < ../Skeleton-pool.conf > $U.conf
# purge old sessions
e /etc/cron.d/php5-user
# minutes from 15-
# 15 *  * * *  $U  [ -d /home/$U/public_html/session ] && /usr/lib/php5/sessionclean /home/$U/public_html/session $(/usr/lib/php5/maxlifetime)

# Apache
cd /etc/apache2/sites-available
sed -e "s/@@SITE_DOMAIN@@/$D/g" -e "s/@@SITE_USER@@/$U/g" < Skeleton-site.conf > $D.conf
# SSL
sed -e "s/@@SITE_DOMAIN@@/$D/g" -e "s/@@SITE_USER@@/$U/g" < Skeleton-site-ssl.conf > $D.conf
# on "www..." set ServerAlias
a2ensite $D
# see: webrestart.sh
# logrotate
e /etc/logrotate.d/apache2-$D
# prerotate & postrotate

# add cron jobs
cd /etc/cron.d/
# webserver/preload-cache.sh
