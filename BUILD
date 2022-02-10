load("@io_bazel_rules_docker//container:container.bzl", "container_image", "container_layer", "container_push")
load("@io_bazel_rules_docker//docker/package_managers:download_pkgs.bzl", "download_pkgs")
load("@io_bazel_rules_docker//docker/package_managers:install_pkgs.bzl", "install_pkgs")
load("@io_bazel_rules_docker//docker/util:run.bzl", "container_run_and_commit", "container_run_and_extract")

#
# Build Server Base Image
#

download_pkgs(
    name = "server_deps",
    image_tar = "@base_image//image",
    packages = [
        "ca-certificates",
        "libcurl4",
        "wine",
        "xvfb",
    ],
)

install_pkgs(
    name = "server_base",
    image_tar = "@base_image//image",
    installables_tar = ":server_deps.tar",
    installation_cleanup_commands = "rm -rf /var/lib/apt/lists/*",
    output_image_name = "server_base",
)

#
# Build Source SDK Base 2006 Dedicated Server Layer
#

container_run_and_extract(
    name = "download_srcds",
    commands = [
        "sed -i -e's/ main/ main non-free/g' /etc/apt/sources.list",
        "echo steam steam/question select 'I AGREE' | debconf-set-selections",
        "echo steam steam/license note '' | debconf-set-selections",
        "apt update",
        "apt install -y steamcmd",
        "/usr/games/steamcmd +@sSteamCmdForcePlatformType windows +login anonymous +force_install_dir /opt/game +app_update 205 +app_update 215 validate +quit",
        "rm -rf /opt/game/steamapps",
        "chown -R nobody:root /opt/game",
        "tar -czvf /archive.tar.gz /opt/game/",
    ],
    extract_file = "/archive.tar.gz",
    image = ":server_base.tar",
)

container_layer(
    name = "srcds",
    tars = [
        ":download_srcds/archive.tar.gz",
    ],
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
    files = [
        "@metamod//file",
        "@sourcemod//file",
    ],
)

container_run_and_extract(
    name = "build_sourcemod",
    commands = [
        "apt-get update",
        "apt-get install -y unzip",
        "mkdir -p /opt/game/hidden",
        "unzip metamod.zip -d /opt/game/hidden",
        "unzip sourcemod.zip -d /opt/game/hidden",
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
# Build LAN of DOOM Plugin Layer
#

container_image(
    name = "plugin_container",
    base = ":server_base",
    files = [
        "@auth_by_steam_group//file",
    ],
)

container_run_and_extract(
    name = "build_plugin",
    commands = [
        "apt-get update",
        "apt-get install -y unzip",
        "mkdir -p /opt/game/hidden",
        "unzip auth_by_steam_group.zip -d /opt/game/hidden",
        "chown -R nobody:root /opt",
        "tar -czvf /archive.tar.gz /opt",
    ],
    extract_file = "/archive.tar.gz",
    image = ":plugin_container.tar",
)

container_layer(
    name = "lanofdoom_plugins",
    tars = [
        ":build_plugin/archive.tar.gz",
    ],
)

#
# Build LAN of DOOM Plugin and Config Layers
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

container_image(
    name = "config_container",
    base = ":server_base",
    layers = [
        ":lanofdoom_server_config",
        ":lanofdoom_server_entrypoint",
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
    name = "lanofdoom_config",
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
        ":lanofdoom_config",
        ":lanofdoom_plugins",
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
