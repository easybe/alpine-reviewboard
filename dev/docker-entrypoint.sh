#!/bin/sh
set -e

cd /src

if [ ! -f settings_local.py ]; then
    python setup.py install_node_deps
    pip install --no-cache-dir -e .
    sed 's/allow_input=True/allow_input=False/' \
        contrib/internal/prepare-dev.py | python
fi

if [ "$1" == "server" ]; then
    shift
    exec contrib/internal/devserver.py "$@"
elif [ "$1" == "test" ]; then
    shift
    exec reviewboard/manage.py test -- "$@"
else
    exec ash
fi
