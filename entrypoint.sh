#!/bin/bash -ue

[ -z "${HIDDEN_ADMIN}" ] || echo "${HIDDEN_ADMIN} \"99:z\"" > hidden/addons/sourcemod/configs/admins_simple.ini

[ -z "${HIDDEN_MOTD}" ] || echo "${HIDDEN_MOTD}" > hidden/motd.txt

#  Hack to make auth plugin load properly
cp hidden/addons/sourcemod/extensions/auth_by_steam_group.ext.1.ep1.dll hidden/addons/sourcemod/extensions/auth_by_steam_group.ext.dll

# Generate mapcycle
ls hidden/maps/*.bsp | grep -v tutorial | sed -e 's/.*\/\([^\/]*\).bsp/\1/' > hidden/cfg/mapcycle.txt

# Update maplists
sed -i 's|addons/sourcemod/configs/adminmenu_maplist.ini|default|g' hidden/addons/sourcemod/configs/maplists.cfg

# Start display server
Xvfb :1 -screen 0 800x600x16 &
sleep 1s

# Configure wine and start game
WINEARCH="win32" wine winecfg
DISPLAY=":1.0" wine start srcds.exe \
    -game hidden \
    -port "$HIDDEN_PORT" \
    -strictbindport \
    -console \
    -tickrate 100 \
    +ip 0.0.0.0 \
    +map "$HIDDEN_MAP" \
    +hostname "$HIDDEN_HOSTNAME" \
    +rcon_password "$RCON_PASSWORD" \
    +sv_password "$HIDDEN_PASSWORD" \
    +sm_auth_by_steam_group_group_id "$STEAM_GROUP_ID" \
    +sm_auth_by_steam_group_steam_key "$STEAM_API_KEY"

wineserver --wait