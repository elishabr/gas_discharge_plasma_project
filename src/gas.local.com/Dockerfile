FROM ubuntu/nginx:1.18-20.04_beta

# переменные среды
ENV NGINX_USER=elishabr \
    NGINX_GROUP=elishabr \
    NGINX_RUN_USER=elishabr \
    NGINX_RUN_GROUP=elishabr

WORKDIR /home

COPY server/server.c /server.c
COPY script_for_image.sh /script_for_image.sh

RUN apt update && apt install -y gcc spawn-fcgi libfcgi-dev curl openssl && \
 rm -rf /var/lib/apt/lists && chmod +x /script_for_image.sh && \
 gcc  -o server1  /server.c -l fcgi

RUN openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048 &&\
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/certs/self.key -out /etc/ssl/certs/self.crt \
    -subj "/C=RU/ST=Moscow/L=Kremlin/O=Azzrael Code/OU=Org/CN=azz.code"

# создать группу и пользователя
RUN groupadd -r $NGINX_GROUP && useradd -r -g $NGINX_GROUP $NGINX_USER
RUN chown $NGINX_RUN_USER:$NGINX_RUN_GROUP /script_for_image.sh server1

# создание дополнительных папок для nginx и установка владельца этих папок
RUN touch /var/run/nginx.pid && \
    mkdir -p /var/cache/nginx /var/log/nginx /var/lib/nginx/body && \
    chown -R $NGINX_RUN_USER:$NGINX_RUN_GROUP /etc/nginx /var/cache/nginx /var/log/nginx /var/run/nginx.pid /var/lib/nginx

# изменяем прова доступа на встроенные утилиты
RUN chmod u-s /usr/bin/gpasswd; \
    chmod u-s /usr/bin/newgrp; \
    chmod u-s /bin/su; \
    chmod u-s /bin/mount; \
    chmod u-s /bin/umount; \
    chmod u-s /usr/bin/chsh; \
    chmod u-s /usr/bin/chfn; \
    chmod u-s /usr/bin/chsh; \
    chmod 255 /usr/bin/expiry; \
    chmod 255 /usr/bin/wall; \
    chmod 255 /sbin/unix_chkpwd; \
    chmod 255 /usr/bin/chage; \
    chmod 255 /usr/sbin/pam_extrausers_chkpwd; \
    chmod 755 /usr/bin/passwd  

# USER $NGINX_RUN_USER

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

ENTRYPOINT ["/script_for_image.sh"]
