#!/bin/bash

nginx -g 'daemon off;' &
spawn-fcgi -p 8080 -n ./server1
# openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048 && \
# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/certs/self.key -out /etc/ssl/certs/self.crt \
#     -subj "/C=RU/ST=Russia/L=Kazan/O=Nikita Kirgizov/OU=Org/CN=gas.local.com"
