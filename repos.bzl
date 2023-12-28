load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def repos(bzlmod = False):
    """Fetches repositories"""

    #
    # Server Dependencies
    #

    http_archive(
        name = "auth_by_steam_group",
        sha256 = "2ce9f93038773affe8d7c7acc4fe156735f095f287889cafeb07fb78f512007d",
        urls = ["https://github.com/lanofdoom/auth-by-steam-group/releases/download/v2.3.0/auth_by_steam_group.zip"],
        build_file_content = "filegroup(name = \"all\", srcs = glob(include = [\"**/*\"], exclude = [\"WORKSPACE\", \"BUILD.bazel\"]), visibility = [\"//visibility:public\"])",
    )

    http_archive(
        name = "hidden",
        sha256 = "ae73d35c42a8521dc0c0ebda99e85f3e731176d04abeb7c6263ca4bca0cfe7ae",
        urls = ["http://www.hidden-source.com/downloads/hsb4b-full.zip"],
        build_file_content = "filegroup(name = \"all\", srcs = glob(include = [\"**/*\"], exclude = [\"WORKSPACE\", \"BUILD.bazel\"]), visibility = [\"//visibility:public\"])",
    )

    http_archive(
        name = "metamod",
        sha256 = "764ef206a00768dc6810ff7344dfabd7b2d8ab4b3d426c5fad49d4818ac3228d",
        urls = ["https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1145-windows.zip"],
        build_file_content = "filegroup(name = \"all\", srcs = glob(include = [\"**/*\"], exclude = [\"WORKSPACE\", \"BUILD.bazel\"]), visibility = [\"//visibility:public\"])",
    )

    http_archive(
        name = "sourcemod",
        sha256 = "1361a2df2b98658c88adb1793fdc152926180ed6c04f7d36457b7de4f8c0c415",
        urls = ["https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6528-windows.zip"],
        build_file_content = "filegroup(name = \"all\", srcs = glob(include = [\"**/*\"], exclude = [\"WORKSPACE\", \"BUILD.bazel\"]), visibility = [\"//visibility:public\"])",
    )

repos_bzlmod = module_extension(implementation = repos)
