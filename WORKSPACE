load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "59536e6ae64359b716ba9c46c39183403b01eabfbd57578e84398b4829ca499a",
    strip_prefix = "rules_docker-0.22.0",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.22.0/rules_docker-v0.22.0.tar.gz"],
)

load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)

container_repositories()

load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")

container_deps()

load("@io_bazel_rules_docker//container:container.bzl", "container_pull")

#
# Server Dependencies
#

http_file(
    name = "auth_by_steam_group",
    downloaded_file_path = "auth_by_steam_group.zip",
    sha256 = "102ac24bc229f1e08164d2b63358703106f1a6bd19d9c6cd47936b259c61873e",
    urls = ["https://lanofdoom.github.io/auth-by-steam-group/releases/v2.3.0/auth_by_steam_group.zip"],
)

http_file(
    name = "hidden",
    downloaded_file_path = "hidden.zip",
    sha256 = "ae73d35c42a8521dc0c0ebda99e85f3e731176d04abeb7c6263ca4bca0cfe7ae",
    urls = ["http://www.hidden-source.com/downloads/hsb4b-full.zip"],
)

http_file(
    name = "metamod",
    downloaded_file_path = "metamod.zip",
    sha256 = "764ef206a00768dc6810ff7344dfabd7b2d8ab4b3d426c5fad49d4818ac3228d",
    urls = ["https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1145-windows.zip"],
)

http_file(
    name = "sourcemod",
    downloaded_file_path = "sourcemod.zip",
    sha256 = "1361a2df2b98658c88adb1793fdc152926180ed6c04f7d36457b7de4f8c0c415",
    urls = ["https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6528-windows.zip"],
)

#
# Container Base Image
#

container_pull(
    name = "base_image",
    registry = "index.docker.io",
    repository = "i386/debian",
    tag = "bullseye-slim",
)