#!/bin/bash
set -eo pipefail

host="$(hostname -i || echo '127.0.0.1')"
if curl -f "http://${host}/" -H "Host: ${NGINX_HOST}" > /dev/null 2>&1; then
    exit 0
fi

exit 1
