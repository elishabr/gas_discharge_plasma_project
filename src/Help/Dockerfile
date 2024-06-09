FROM nginx:latest
WORKDIR /home/
COPY server/server.c .
COPY server/graph.png .
COPY script_for_image.sh .
RUN apt update && apt install -y gcc spawn-fcgi libfcgi-dev
USER nginx
ENTRYPOINT ["/usr/bin/bash","./script_for_image.sh" ]