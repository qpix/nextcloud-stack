#!/bin/bash

source /root/certbot.env

if [ -d "/etc/letsencrypt/live/"$DOMAIN ]; then
	echo "INFO: Renewing certificate."
	certbot renew -n $OPTIONS
else
	echo "INFO: Installing certificate."
	cp /root/proxy.conf /etc/nginx/conf.d/
	sed -i "s/%DOMAIN%/$DOMAIN/g" /etc/nginx/conf.d/proxy.conf
	certbot --nginx --email $EMAIL -d $DOMAIN --agree-tos -n $OPTIONS
fi

nginx -s quit

nginx -g "daemon off;"
