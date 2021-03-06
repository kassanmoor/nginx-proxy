#!/bin/sh

# Used in certificate path
export CERTNAME=`python /certbot-certname.py`
envsubst '$HTTP_DOMAINS, $HTTPS_DOMAINS, $CERTNAME' < "http.conf" > "http.conf~"
envsubst '$HTTP_DOMAINS, $HTTPS_DOMAINS, $CERTNAME' < "https.conf" > "https.conf~"

mv http.conf~ http.conf
mv https.conf~ https.conf

if [ ! -e /etc/letsencrypt/live ]; then
  certbot certonly --standalone --non-interactive $CERTBOT_ARGS \
    --agree-tos --email $CERTBOT_EMAIL \
    `python /certbot-domains.py`
fi

if [ ! -e /var/lib/letsencrypt/dhparam.pem ]; then
  openssl dhparam -out /var/lib/letsencrypt/dhparam.pem 2048
fi

crond
nginx -g "daemon off;"
