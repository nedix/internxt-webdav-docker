#!/usr/bin/env sh

: ${AUTH_CODE}
: ${EMAIL}
: ${PASSWORD}

/usr/local/bin/internxt login \
    --non-interactive \
    --email="$EMAIL" \
    --password="$PASSWORD" \
    $([ -z "$AUTH_CODE" ] || echo --twofactor="$AUTH_CODE")
