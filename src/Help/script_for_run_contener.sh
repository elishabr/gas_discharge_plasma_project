docker build -t gas_server:1.0 .
docker run -d -p 80:81 --name gas_server -v /etc/nginx:/etc/nginx gas_server:1.0
curl http://localhost:80/status 