#!/bin/bash -ue

[ -z "${HIDDEN_ADMIN}" ] || echo "${HIDDEN_ADMIN} \"99:z\"" > /opt/game/hidden/addons/sourcemod/configs/admins_simple.ini

[ -z "${HIDDEN_MOTD}" ] || echo "${HIDDEN_MOTD}" > /opt/game/hidden/motd.txt

/usr/bin/Xvfb :99 -screen 0 16x16x8 &

# Call srcds_linux instead of srcds_run to avoid restart logic
DISPLAY=:99 /usr/bin/wine /opt/game/srcds.exe \
    -game hidden \
    -port "$HIDDEN_PORT" \
    -strictbindport \
    -usercon \
    -tickrate 100 \
    +ip 0.0.0.0 \
    +map "$HIDDEN_MAP" \
    +hostname "$HIDDEN_HOSTNAME" \
    +rcon_password "$RCON_PASSWORD" \
    +sv_password "$HIDDEN_PASSWORD" \
    +sm_auth_by_steam_group_group_id "$STEAM_GROUP_ID" \
    +sm_auth_by_steam_group_steam_key "$STEAM_API_KEY"
