#!/usr/bin/env sh

export WEBDAV_SERVER_PORT=443

cd /usr/local/lib/node_modules/@internxt/cli

setsid /usr/local/bin/node /usr/local/lib/node_modules/@internxt/cli/dist/webdav/index.js 2> /dev/null
