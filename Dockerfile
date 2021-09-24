FROM alpine:3

RUN apk add --no-cache php7-cli php7-json bash wget busybox shadow

WORKDIR /var/www/keeweb-local-server

# Set user and group
ARG user=appuser
ARG group=appuser
ARG uid=1000
ARG gid=1000
RUN groupadd -g ${gid} ${group} && useradd -u ${uid} -g ${group} -s /bin/sh -m ${user} && chown -R ${uid}:${gid} .

# Switch to user
USER ${uid}:${gid}

ARG KEEWEB_VERSION
ENV KEEWEB_VERSION=${KEEWEB_VERSION:-1.18.7}
RUN wget -O- https://github.com/keeweb/keeweb/releases/download/v${KEEWEB_VERSION}/KeeWeb-${KEEWEB_VERSION}.html.zip | busybox unzip - && \
    sed -i 's/content="(no-config)"/content="config.json"/' index.html
ADD . /var/www/keeweb-local-server

EXPOSE 8080
ENTRYPOINT ["php", "-S", "0.0.0.0:8080"]
