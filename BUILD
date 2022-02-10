load("@io_bazel_rules_docker//container:container.bzl", "container_image", "container_layer", "container_push")
load("@io_bazel_rules_docker//docker/util:run.bzl", "container_run_and_commit", "container_run_and_extract")
load("@com_github_lanofdoom_steamcmd//:defs.bzl", "steam_depot_layer")

container_run_and_commit(
    name = "server_base",
    image = "@base_image//image",
    commands = [
        "dpkg --add-architecture i386",
        "apt-get update",
        "apt-get install -y ca-certificates lib32gcc-s1 libcurl4:i386 libsdl2-2.0-0:i386 wine:i386 xvfb",
        "rm -rf /var/lib/apt/lists/*",
    ],
)

#
# Build Source SDK Base 2006 Dedicated Server Layer
#

steam_depot_layer(
    name = "srcds",
    os = "windows",
    app = "205",
    depot = "215",
    directory = "/opt/game",
)

#
# Build Hidden Layer
#

container_image(
    name = "hidden_container",
    base = ":server_base",
    files = [
        "@hidden//file",
    ],
)

container_run_and_extract(
    name = "hidden_extract",
    commands = [
        "apt-get update",
        "apt-get install -y unzip",
        "mkdir -p /opt/game",
        "unzip hidden.zip -d /opt/game",
        "chown -R nobody:root /opt",
        "tar -czvf /archive.tar.gz /opt",
    ],
    extract_file = "/archive.tar.gz",
    image = ":hidden_container.tar",
)

container_layer(
    name = "hidden",
    tars = [
        ":hidden_extract/archive.tar.gz",
    ],
)

#
# Build Sourcemod Layer
#

container_image(
    name = "sourcemod_container",
    base = ":server_base",
    directory = "/opt/game/hidden",
    tars = [
        "@metamod//file",
        "@sourcemod//file",
    ],
)

container_run_and_extract(
    name = "build_sourcemod",
    commands = [
        "cd /opt/game/hidden/addons/sourcemod",
        "mv plugins/basevotes.smx plugins/disabled/basevotes.smx",
        "mv plugins/funcommands.smx plugins/disabled/funcommands.smx",
        "mv plugins/funvotes.smx plugins/disabled/funvotes.smx",
        "mv plugins/playercommands.smx plugins/disabled/playercommands.smx",
        "mv plugins/disabled/mapchooser.smx plugins/mapchooser.smx",
        "mv plugins/disabled/rockthevote.smx plugins/rockthevote.smx",
        "mv plugins/disabled/nominations.smx plugins/nominations.smx",
        "chown -R nobody:root /opt",
        "tar -czvf /archive.tar.gz /opt",
    ],
    extract_file = "/archive.tar.gz",
    image = ":sourcemod_container.tar",
)

container_layer(
    name = "sourcemod",
    tars = [
        ":build_sourcemod/archive.tar.gz",
    ],
)

#
# Build LAN of DOOM Plugin and Config Layer
#

container_layer(
    name = "lanofdoom_server_config",
    directory = "/opt/game/hidden/cfg",
    files = [
        ":server.cfg",
    ],
)

container_layer(
    name = "lanofdoom_server_rtv_config",
    directory = "/opt/game/hidden/cfg/sourcemod",
    files = [
        ":rtv.cfg",
    ]
)

container_layer(
    name = "lanofdoom_server_entrypoint",
    directory = "/opt/game",
    files = [
        ":entrypoint.sh",
    ],
)

container_layer(
    name = "lanofdoom_server_plugins",
    directory = "/opt/game/hidden",
    tars = [
        "@auth_by_steam_group//file",
    ],
)

container_image(
    name = "config_container",
    base = ":server_base",
    layers = [
        ":lanofdoom_server_config",
        ":lanofdoom_server_entrypoint",
        ":lanofdoom_server_plugins",
        ":lanofdoom_server_rtv_config",
    ],
)

container_run_and_extract(
    name = "build_lanofdoom",
    commands = [
        "chown -R nobody:root /opt",
        "tar -czvf /archive.tar.gz /opt",
    ],
    extract_file = "/archive.tar.gz",
    image = ":config_container.tar",
)

container_layer(
    name = "lanofdoom",
    tars = [
        ":build_lanofdoom/archive.tar.gz",
    ],
)

#
# Build Final Image
#

container_image(
    name = "server_image",
    base = ":server_base",
    entrypoint = ["/opt/game/entrypoint.sh"],
    env = {
        "HIDDEN_ADMIN": "",
        "HIDDEN_HOSTNAME": "",
        "HIDDEN_MAP": "hdn_traindepot",
        "HIDDEN_MOTD": "",
        "HIDDEN_PASSWORD": "",
        "HIDDEN_PORT": "27015",
        "RCON_PASSWORD": "",
        "STEAM_GROUP_ID": "",
        "STEAM_API_KEY": "",
    },
    layers = [
        ":srcds",
        ":hidden",
        ":sourcemod",
        ":lanofdoom_server_config",
        ":lanofdoom_server_plugins",
        ":lanofdoom_server_entrypoint",
    ],
    workdir = "/opt/game",
)

container_push(
    name = "push_server_image",
    format = "Docker",
    image = ":server_image",
    registry = "ghcr.io",
    repository = "lanofdoom/hidden-server",
    tag = "latest",
)
