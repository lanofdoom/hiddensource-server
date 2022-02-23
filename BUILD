load("@io_bazel_rules_docker//container:container.bzl", "container_image", "container_layer", "container_push")
load("@io_bazel_rules_docker//docker/package_managers:download_pkgs.bzl", "download_pkgs")
load("@io_bazel_rules_docker//docker/package_managers:install_pkgs.bzl", "install_pkgs")
load("@io_bazel_rules_docker//docker/util:run.bzl", "container_run_and_commit", "container_run_and_extract")

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
        "apt install -y ca-certificates steamcmd",
        "/usr/games/steamcmd +@sSteamCmdForcePlatformType windows +login anonymous +force_install_dir /opt/game +app_update 205 +app_update 215 validate +quit",
        "rm -rf /opt/game/steamapps",
        "chown -R nobody:root /opt/game",
        "tar -czvf /archive.tar.gz /opt/game/",
    ],
    extract_file = "/archive.tar.gz",
    image = "@base_image//image",
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
    base = "@base_image//image",
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
# MetaMod Layer
#

container_image(
    name = "metamod_container",
    base = "@base_image//image",
    files = [
        "@metamod//file",
    ],
)

container_run_and_extract(
    name = "metamod_extract",
    commands = [
        "apt-get update",
        "apt-get install -y unzip",
        "mkdir -p /opt/game/hidden",
        "unzip metamod.zip -d /opt/game/hidden",
        "tar -czvf /archive.tar.gz /opt",
    ],
    extract_file = "/archive.tar.gz",
    image = ":metamod_container.tar",
)

container_layer(
    name = "metamod",
    tars = [
        ":metamod_extract/archive.tar.gz",
    ],
)

#
# SourceMod Layer
#

container_image(
    name = "sourcemod_container",
    base = "@base_image//image",
    files = [
        "@sourcemod//file",
    ],
)

container_run_and_extract(
    name = "sourcemod_extract",
    commands = [
        "apt-get update",
        "apt-get install -y unzip",
        "mkdir -p /opt/game/hidden",
        "unzip sourcemod.zip -d /opt/game/hidden",
        "tar -czvf /archive.tar.gz /opt",
    ],
    extract_file = "/archive.tar.gz",
    image = ":sourcemod_container.tar",
)

container_layer(
    name = "sourcemod",
    tars = [
        ":sourcemod_extract/archive.tar.gz",
    ],
)

#
# Authorization Layer
#

container_image(
    name = "authorization_container",
    base = "@base_image//image",
    files = [
        "@auth_by_steam_group//file",
    ],
)

container_run_and_extract(
    name = "authorization_extract",
    commands = [
        "apt-get update",
        "apt-get install -y unzip",
        "mkdir -p /opt/game/hidden",
        "unzip auth_by_steam_group.zip -d /opt/game/hidden",
        "tar -czvf /archive.tar.gz /opt",
    ],
    extract_file = "/archive.tar.gz",
    image = ":authorization_container.tar",
)

container_layer(
    name = "authorization",
    tars = [
        ":authorization_extract/archive.tar.gz",
    ],
)

#
# Config Layer
#

container_layer(
    name = "config",
    directory = "/opt/game/hidden/cfg",
    files = [
        ":server.cfg",
    ],
)

#
# Build Server Base Image
#

download_pkgs(
    name = "server_deps",
    image_tar = "@base_image//image",
    packages = [
        "ca-certificates",
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
# Build Final Image
#

container_image(
    name = "server_image",
    base = ":server_base",
    entrypoint = ["/entrypoint.sh"],
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
    files = [
        ":entrypoint.sh",
    ],
    layers = [
        ":srcds",
        ":hidden",
        ":metamod",
        ":sourcemod",
        ":authorization",
        ":config",
    ],
)

container_push(
    name = "push_server_image",
    format = "Docker",
    image = ":server_image",
    registry = "ghcr.io",
    repository = "lanofdoom/hiddensource-server",
    tag = "latest",
)
