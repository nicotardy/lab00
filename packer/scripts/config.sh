#!/usr/bin/env bash
apt-get update -q
apt-get upgrade -y
apt-get install -y git nginx
rm /etc/nginx/sites-enabled/default 
cat > /etc/nginx/conf.d/webapp.conf <<EOF
server {
    listen 80;
    server_name _;
    root /var/webapp;
}
EOF
mkdir /var/webapp
cp /tmp/index.html /var/webapp/
HOST=`hostname`
sed -i "s#everybody#NicoBuildOnPacker at $HOST#" /var/webapp/index.html
systemctl restart nginx
