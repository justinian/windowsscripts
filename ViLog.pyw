#!/usr/bin/env python3

def build_path(name):
    import os
    from os.path import expanduser, join
    db_path = os.environ.get("DROPBOX_PATH", join(expanduser("~"), "Dropbox"))
    return join(db_path, "Work", "Daily", name)


def log_name():
    from datetime import datetime
    return build_path("{now:%Y.%m.%d}.md".format(now=datetime.now()))


def edit(name):
    from subprocess import Popen
    args = [
        "gvim",
        "--servername",
        "vilog",
        "--remote-silent",
        name
        ]

    Popen(args, shell=True)


def ensure(name):
    import os.path
    if not os.path.exists(name):
        import shutil
        shutil.copy(build_path("template.md"), name)
    return name


if __name__ == "__main__":
    edit(ensure(log_name()))
