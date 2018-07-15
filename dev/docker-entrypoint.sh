#!/bin/sh
set -e

cd /src

if [ ! -f settings_local.py ]; then
    python setup.py install_node_deps
    pip install --no-cache-dir -e .
    sed 's/allow_input=True/allow_input=False/' \
        contrib/internal/prepare-dev.py | python
fi

case $1 in
    server)
        shift
        exec contrib/internal/devserver.py "$@"
        ;;
    test)
        shift
        exec reviewboard/manage.py test -- "$@"
        ;;
    manage)
        shift
        exec reviewboard/manage.py "$@"
        ;;
    *)
        exec ash
esac
