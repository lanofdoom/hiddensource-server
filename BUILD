load("@io_bazel_rules_docker//container:container.bzl", "container_image", "container_layer", "container_push")
load("@io_bazel_rules_docker//docker/package_managers:download_pkgs.bzl", "download_pkgs")
load("@io_bazel_rules_docker//docker/package_managers:install_pkgs.bzl", "install_pkgs")
load("@com_github_lanofdoom_steamcmd//:defs.bzl", "steam_depot_layer")

#
# Source SDK Base 2006 Layer
#

steam_depot_layer(
    name = "sdk",
    app = "215",
    directory = "/opt/game",
    os = "windows",
)

#
# Hidden Layer
#

container_layer(
    name = "hidden",
    data_path = "./../hidden",
    directory = "/opt/game",
    files = [
        "@hidden//:all",
    ],
)

#
# MetaMod Layer
#

container_layer(
    name = "metamod",
    data_path = "./../metamod",
    directory = "/opt/game/hidden",
    files = [
        "@metamod//:all",
    ],
)

#
# SourceMod Layer
#

container_layer(
    name = "sourcemod",
    data_path = "./../sourcemod",
    directory = "/opt/game/hidden",
    files = [
        "@sourcemod//:all",
    ],
)

#
# Authorization Layer
#

container_layer(
    name = "authorization",
    data_path = "./../auth_by_steam_group",
    directory = "/opt/game/hidden",
    files = [
        "@auth_by_steam_group//:all",
    ],
)

#
# Config Layer
#

container_layer(
    name = "config",
    directory = "/opt/game/hidden/cfg/templates",
    files = [
        ":server.cfg",
    ],
)

#
# Server Base Image
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
        ":sdk",
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
