#!/usr/bin/env sh

setsid /opt/internxt-webdav/mitmproxy/mitmdump.py \
    --set "flow_detail=1" \
    --set "termlog_verbosity=error" \
    --set "listen_host=0.0.0.0" \
    --set "listen_port=80" \
    --mode "reverse:https://127.0.0.1:443" \
    --set "ssl_insecure=true" \
    -s "/opt/internxt-webdav/mitmproxy/scripts/add-move-support.py"
