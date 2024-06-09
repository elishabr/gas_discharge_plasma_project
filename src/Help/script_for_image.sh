#!/bin/bash

gcc -o server1 server.c -lfcgi
spawn-fcgi -p 8080 ./server1 &
nginx -g 'daemon off;'

#gcc -o gas_chart server/gas_chart.c -lfcgi -lgd -lpng -lz