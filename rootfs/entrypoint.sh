#!/usr/bin/env sh

: ${INTERNXT_AUTH_CODE}
: ${INTERNXT_EMAIL}
: ${INTERNXT_PASSWORD}

# -------------------------------------------------------------------------------
#       Bootstrap internxt services
# -------------------------------------------------------------------------------
{
    # -------------------------------------------------------------------------------
    #       Create internxt-login environment
    # -------------------------------------------------------------------------------
    mkdir -p "/run/internxt-login/environment"

    echo "$INTERNXT_AUTH_CODE" > "/run/internxt-login/environment/AUTH_CODE"
    echo "$INTERNXT_EMAIL"     > "/run/internxt-login/environment/EMAIL"
    echo "$INTERNXT_PASSWORD"  > "/run/internxt-login/environment/PASSWORD"

    chmod -R 400 "/run/internxt-login/environment"
}

# -------------------------------------------------------------------------------
#    Create executables
# -------------------------------------------------------------------------------
for BIN in /etc/s6-overlay/s6-rc.d/*/bin/*.sh; do
    ENVIRONMENT=$(echo "$BIN" | sed "s|/etc/s6-overlay/s6-rc\.d/\(.*\)/bin/.*\.sh|/run/\1/environment|")
    SCRIPT=$(echo "$BIN" | sed "s|\(/etc/s6-overlay/s6-rc\.d/.*/\)bin/\(.*\)\.sh|\1\2|")
    SERVICE=$(echo "$BIN" | sed "s|/etc/s6-overlay/s6-rc\.d/\(.*\)/bin/.*\.sh|\1|")

    if [ -f "$SCRIPT" ]; then
        continue
    fi

    if [ -d "$ENVIRONMENT" ]; then
cat << EOF > "$SCRIPT"
#!/usr/bin/execlineb -P
exec s6-envdir "$ENVIRONMENT" "$BIN"
EOF
    else
cat << EOF > "$SCRIPT"
#!/usr/bin/execlineb -P
exec "$BIN"
EOF
    fi
done

# -------------------------------------------------------------------------------
#    Let's go!
# -------------------------------------------------------------------------------
exec env -i \
    PATH="/opt/internxt-webdav/bin:${PATH}" \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME="$(( 30 * 1000 ))" \
    /init
