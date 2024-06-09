## Для установки SSL сертификата будем использовать бесплатные SSL сертификаты от Let’s Encrypt
- [Let’s Encrypt](https://letsencrypt.org/ru/about/)
- Установка Certbot:
```
    sudo apt install certbot python3-certbot-nginx
```
- Certbot прочитает нашу конфигурацию Nginx и увидит все параметры указанные в пункте server_name: и для данных IP адресов будут установлены SSL сертификаты
- Команда для запуска Certbot:
```
    sudo certbot --nginx -d gas.local.com --register-unsafely-whithout-email
```
- Флаг --register-unsafely-whithout-email указываем если не хотим вводить email
- Соглашаемся с требованиями 
- В последнем шаге можно казать чтобы происходило перенаправление на https соединение `2`
- Конфигурация до изменения 
- ![](images/part01.png)
## Создание самоподписанного серификата 
- Устанавиливаем `openssl`
```
    sudo apt install openssl
```
- Создать файл по указоному пути /etc/nginx/ssl-params.conf и добавить в негл следующую конфигурацию
```
    # это просто копипаста с просторов,
    # настройки могут быть и другими
    
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_ciphers "EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5";
    ssl_ecdh_curve secp384r1;
    ssl_session_cache shared:SSL:10m;
    ssl_session_tickets off;
    ssl_stapling on;
    ssl_stapling_verify on;
    resolver 8.8.8.8 8.8.4.4 valid=300s;
    resolver_timeout 5s;
    
    # Disable preloading HSTS for now. You can use the commented out header line that includes
    # the "preload" directive if you understand the implications.
    #add_header Strict-Transport-Security "max-age=63072000; includeSubdomains; preload";
    add_header Strict-Transport-Security "max-age=63072000; includeSubdomains";
    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;
    ssl_dhparam /etc/ssl/certs/dhparam.pem;
```
- В файл nginx.conf изменить, добавив в конфигурацию параметры для SSL сертификациии. В нашем случае /etc/nginx/available/gas.local.com
```
    server {
        listen 81 default_server;
        #listen [::]:81 default_server;
        listen 443 ssl http2 default_server;

        ssl_certificate /etc/ssl/certs/self.crt;
        ssl_certificate_key /etc/ssl/certs/self.key;
        include /etc/nginx/ssl-params.conf;

        server_name gas.local.com;
        root /var/www/images;
        location / {
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_pass  localhost:8080;
        }

        location ~ \.(gif|jpg|png)$ {
            root /var/www/images;
        }

        location /status {
            stub_status;
            allow all;
        }
    }
```
- Запустить команду 
```
    sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048 && \
    sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/certs/self.key -out /etc/ssl/certs/self.crt \
    -subj "/C=RU/ST=Russia/L=Kazan/O=Nikita Kirgizov/OU=Org/CN=gas.local.com"
```
