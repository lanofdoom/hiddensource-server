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
# Steam Dependencies
#

git_repository(
    name = "com_github_lanofdoom_steamcmd",
    commit = "bbeb7373f047aa3271d9f3442bc7985a6049f879",
    remote = "https://github.com/lanofdoom/steamcmd",
)

load("@com_github_lanofdoom_steamcmd//:repositories.bzl", "steamcmd_repos")

steamcmd_repos()

load("@com_github_lanofdoom_steamcmd//:deps.bzl", "steamcmd_deps")

steamcmd_deps()

load("@com_github_lanofdoom_steamcmd//:nugets.bzl", "steamcmd_nugets")

steamcmd_nugets()

#
# Server Dependencies
#

http_file(
    name = "auth_by_steam_group",
    downloaded_file_path = "auth_by_steam_group.tar.gz",
    sha256 = "2b912b1df5331cf58868df283fdcf3e226b7a50e0a2170f7fd0d0581b18b1fdc",
    urls = ["https://lanofdoom.github.io/auth-by-steam-group/releases/v2.2.0/auth_by_steam_group.tar.gz"],
)

http_file(
    name = "hidden",
    downloaded_file_path = "hidden.zip",
    sha256 = "ae73d35c42a8521dc0c0ebda99e85f3e731176d04abeb7c6263ca4bca0cfe7ae",
    urls = ["http://www.hidden-source.com/downloads/hsb4b-full.zip"],
)

http_file(
    name = "metamod",
    downloaded_file_path = "metamod.tar.gz",
    sha256 = "b7fc903755bb3f273afd797b36e94844b828e721d291d2a7519eecad3fa8486c",
    urls = ["https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1145-linux.tar.gz"],
)

http_file(
    name = "sourcemod",
    downloaded_file_path = "sourcemod.tar.gz",
    sha256 = "da1fa6c77f3268b6eb8bbdb97e9bf1d03f4084b3f0d1933e195752b44332d3b0",
    urls = ["https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6528-linux.tar.gz"],
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