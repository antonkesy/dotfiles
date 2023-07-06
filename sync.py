import os
import argparse
import pathlib
import shutil

script_file_path = pathlib.Path(os.path.dirname(os.path.realpath(__file__)))


def get_all_files() -> list[str]:
    ignore_directories = [
        ".git",
        "test",
    ]

    ignore_files = [
        "README.md",
        "sync.py",
        ".gitignore",
        "test.sh",
    ]

    all_files = [
        os.path.join(dirpath, f)
        # TODO not working if py call coming from outside of repo dir
        for (dirpath, _, filenames) in os.walk(".")
        for f in filenames
    ]

    for dir in ignore_directories:
        all_files = [f for f in all_files if not f.startswith("." + os.path.sep + dir)]

    for file in ignore_files:
        all_files = [f for f in all_files if f != "." + os.path.sep + file]

    return all_files


def parse_args():
    parser = argparse.ArgumentParser(
        prog="SyncFiles",
        description="Sync dotfiles between repo and home directory",
        epilog=":)",
    )
    parser.add_argument("--toRepo", action="store_true")
    parser.add_argument("--toHome", action="store_true")
    parser.add_argument("--list", action="store_true")

    args = parser.parse_args()
    if args.list:
        print(get_all_files())

    if args.toRepo and args.toHome:
        parser.error("You can't use both --toRepo and --toHome")
    if not args.toRepo and not args.toHome:
        parser.error("You must use --toRepo and --toHome")

    if args.toRepo:
        print("Copy to repository")
        copyToRepo()
    if args.toHome:
        print("Copy to home directory")
        copyToHome()


def copyFromTo(src_prefix, dest_prefix, files):
    print(f"Copying {len(files)} files from {src_prefix} to {dest_prefix}")
    for file in files:
        src_path = pathlib.Path(src_prefix).joinpath(file)
        dest_path = pathlib.Path(dest_prefix).joinpath(file)
        print(f"Copying {src_path} to {dest_path}")
        try:
            shutil.copy2(src_path, dest_path)
        except Exception:
            print("Failed!")


def copyToRepo():
    copyFromTo(pathlib.Path.home(), script_file_path, get_all_files())


def copyToHome():
    copyFromTo(script_file_path, pathlib.Path.home(), get_all_files())


if __name__ == "__main__":
    parse_args()
