sudo systemctl nginx start
sudo service nginx status  
gcc -o server1 server/server.c -lfcgi
spawn-fcgi -p 8080 ./server1