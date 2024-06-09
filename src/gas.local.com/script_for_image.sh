#!/bin/bash

nginx -g 'daemon off;' &
spawn-fcgi -p 8080 -n ./server1
