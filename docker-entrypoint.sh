#!/bin/sh

RB_ROOT=${RB_ROOT:-/var/www/reviewboard}

wait-for db:$DB_PORT -t 60

if [ -e $RB_ROOT/conf/settings_local.py ]; then
    rb-site upgrade $RB_ROOT
else
    rb-site install \
            --noinput \
            --domain-name="$(hostname --fqdn)" \
            --company="$RB_COMPANY" \
            --site-root=/ \
            --static-url=static/ \
            --media-url=media/ \
            --db-type="$DB_TYPE" \
            --db-name="$DB_NAME" \
            --db-host="db" \
            --db-user="$DB_USER" \
            --db-pass="$DB_PASSWORD" \
            --cache-type=memcached \
            --cache-info="memcached" \
            --web-server-type=lighttpd \
            --web-server-port=8000 \
            --admin-user="$RB_ADMIN" \
            --admin-password="$RB_PASSWORD" \
            --admin-email="$RB_ADMIN_EMAIL" \
            $RB_ROOT

    chown -R uwsgi:uwsgi \
          /var/www/reviewboard/data \
          /var/www/reviewboard/htdocs/static \
          /var/www/reviewboard/htdocs/media \
          /var/www/reviewboard/logs \
          /var/www/reviewboard/tmp \
          /var/log/uwsgi
fi

exec su -s /bin/sh -c "uwsgi --ini /etc/reviewboard/uwsgi.ini" uwsgi
