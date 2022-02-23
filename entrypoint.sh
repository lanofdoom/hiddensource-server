#!/bin/bash -ue

[ -z "${HIDDEN_MOTD}" ] || echo "${HIDDEN_MOTD}" > /opt/game/hidden/motd.txt

#  Hack to make auth plugin load properly
cp /opt/game/hidden/addons/sourcemod/extensions/auth_by_steam_group.ext.1.ep1.dll /opt/game/hidden/addons/sourcemod/extensions/auth_by_steam_group.ext.dll

# Generate mapcycle
ls /opt/game/hidden/maps/*.bsp | grep -v tutorial | sed -e 's/.*\/\([^\/]*\).bsp/\1/' > /opt/game/hidden/cfg/mapcycle.txt

# Update maplists
sed -i 's|addons/sourcemod/configs/adminmenu_maplist.ini|default|g' /opt/game/hidden/addons/sourcemod/configs/maplists.cfg

# Touch these files to prevent sourcemod from creating them and overriding
# values sent in server.cfg
touch /opt/game/hidden/cfg/sourcemod/mapchooser.cfg
touch /opt/game/hidden/cfg/sourcemod/rtv.cfg

# Set terminal
export TERM=xterm

# Start display server
Xvfb :1 -screen 0 800x600x16 &
sleep 1s

# Create temporary wine root
export WINEPREFIX=$(mktemp -d)

# CD into game directory
cd /opt/game

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