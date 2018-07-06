FROM alpine:3.7

RUN apk --no-cache add \
        uwsgi-python \
        uwsgi-http \
        patch \
        git \
        subversion \
        cvs \
        py-pip \
        py-pynacl \
        py-cffi \
        py-pillow \
        py-bcrypt \
        py-cryptography \
        py-mysqldb \
        py-psycopg2 \
        su-exec

RUN apk --no-cache add \
        gcc \
        g++ \
        musl-dev \
        python2-dev \
        apr-util-dev \
        subversion-dev \
        openssl && \
    pip install --no-cache-dir \
        python-ldap \
        subvertpy \
        mercurial \
        bzr \
        p4python && \
    apk del \
        gcc \
        g++ \
        musl-dev \
        python2-dev \
        apr-util-dev \
        subversion-dev \
        openssl

RUN pip install ReviewBoard==3.0.8

RUN wget -O /usr/local/bin/wait-for https://raw.githubusercontent.com/eficode/wait-for/master/wait-for && \
    chmod +x /usr/local/bin/wait-for

COPY uwsgi.ini /etc/reviewboard/uwsgi.ini
COPY docker-entrypoint.sh /docker-entrypoint.sh

ENV RB_COMPANY="Example Inc." \
    RB_ADMIN=admin \
    RB_ADMIN_PASSWORD=admin \
    RB_ADMIN_EMAIL=admin@example.com \
    DB_TYPE=mysql \
    DB_PORT=3306 \
    DB_NAME=reviewboard \
    DB_USER=reviewboard \
    DB_PASSWORD=reviewboard \
    UWSGI_PROCESSES=10

VOLUME "/var/www"
EXPOSE 8000

CMD ["/docker-entrypoint.sh"]
