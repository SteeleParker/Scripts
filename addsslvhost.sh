#!/bin/bash

# Source https://www.webtipblog.com/bash-script-create-apache-virtual-hosts/
# Usage sudo ./addvhost.sh -u newsite.local -d mynewsite/web

# permissions
if [ "$(whoami)" != "root" ]; then
	echo "Root privileges are required to run this, try running with sudo..."
	exit 2
fi

current_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
hosts_path="/etc/hosts"
vhosts_path="/home/bitnami/stack/apache2/conf/vhosts/"
vhost_skeleton_path="$current_directory/vhostssl.skeleton.conf"
web_root="/home/bitnami/www/"

# user input passed as options?
site_url=0
relative_doc_root=0
site_port=0

while getopts ":u:d:p:" o; do
	case "${o}" in
		u)
			site_url=${OPTARG}
			;;
		d)
			relative_doc_root=${OPTARG}
			;;
		p)
			site_port=${OPTARG}
			;;
	esac
done

# prompt if not passed as options
if [ $site_url == 0 ]; then
	read -p "Please enter the desired URL: " site_url
fi

if [ $site_port == 0 ]; then
	read -p "Please enter the port that this application will be served on PM2: " site_port
fi

# Default the relative doc root to the site url
if [ $relative_doc_root == 0 ]; then
	relative_doc_root=$site_url
#	read -p "Please enter the site path relative to the web root: $web_root_path" relative_doc_root
fi

# Guarantee apache is listening on 443
isListening="$(cat ~/stack/apache2/conf/httpd.conf | grep 'listen 443')"
if [  ${#isListening} == 0 ]; then 
	# Make apache listen on 443
	echo "
Listen 443" >> ~/stack/apache2/conf/httpd.conf
fi;

# construct absolute path
absolute_doc_root=$web_root$relative_doc_root

# create directory if it doesn't exists
if [ ! -d "$absolute_doc_root" ]; then

	# create directory
	`mkdir "$absolute_doc_root/"`
	`chown -R $SUDO_USER:staff "$absolute_doc_root/"`

	# create index file
	indexfile="$absolute_doc_root/index.html"
	`touch "$indexfile"`
	echo "<html><head></head><body>Welcome!</body></html>" >> "$indexfile"

	echo "Created directory $absolute_doc_root/"
fi

# Stop Apache (for certbot)
echo "Stopping Apache..."
echo `sudo /opt/bitnami/ctlscript.sh stop apache`

# Create the SSL Certificate
certbot certonly --standalone --preferred-challenges http -d $site_url --email steele@sparkbusinesstechnology.com.au --agree-tos --no-eff-email

# update vhost
vhost=`cat "$vhost_skeleton_path"`
vhost=${vhost//@site_url@/$site_url}
vhost=${vhost//@site_docroot@/$absolute_doc_root}
vhost=${vhost//@site_port@/$site_port}

`touch $vhosts_path$site_url.ssl.conf`
echo "$vhost" > "$vhosts_path$site_url.ssl.conf"
echo "Updated vhosts in Apache config"

# create htaccess file forcing https usage
htaccessfile="$absolute_doc_root/.htaccess"
`touch "$htaccessfile"`
echo "RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]" >> "$htaccessfile"

# Start Apache
echo "Starting Apache..."
echo `sudo /opt/bitnami/ctlscript.sh start apache`

echo "Process complete, check out the new site at https://$site_url"
