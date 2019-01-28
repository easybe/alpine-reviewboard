#!/bin/sh
set -e

RB_ROOT=${RB_ROOT:-/var/www/reviewboard}

wait-for db:$DB_PORT -t 60

if [ -e $RB_ROOT/conf/settings_local.py ]; then
    rb-site upgrade $RB_ROOT
else
    rb-site install \
            --noinput \
            --domain-name="${VIRTUAL_HOST:-*}" \
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
            --admin-password="$RB_ADMIN_PASSWORD" \
            --admin-email="$RB_ADMIN_EMAIL" \
            $RB_ROOT

    cat << EOF >> $RB_ROOT/conf/settings_local.py

LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
        },
    },
    'loggers': {
        'djblets': {
            'handlers': ['console'],
            'level': 'INFO',
        },
    },
}
EOF

fi

chown -R uwsgi:uwsgi \
    $RB_ROOT/data \
    $RB_ROOT/htdocs/static \
    $RB_ROOT/htdocs/media \
    $RB_ROOT/logs \
    $RB_ROOT/tmp \
    /var/log/uwsgi

exec su-exec uwsgi uwsgi --ini /etc/reviewboard/uwsgi.ini
