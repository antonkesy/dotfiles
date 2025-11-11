import sys
import subprocess
import yaml
from pathlib import Path
from typing import Dict

sys.path.append(str(Path(__file__).parent.parent))
from distros.distro import get_os_type

os_type = get_os_type()


def get_package_info(package_name: str) -> Dict:
    script_dir = Path(__file__).parent
    package_file = script_dir / f"{package_name}.yaml"

    if not package_file.exists():
        print(f"Package file not found: {package_file}", file=sys.stderr)
        sys.exit(1)

    with open(package_file) as f:
        data = yaml.safe_load(f)

    return data.get("package", {})


def check_skip_conditions(package_info: Dict) -> bool:
    skip_conditions = package_info.get("skip_if_all_true", [])

    if not skip_conditions:
        return False

    print("Checking skip conditions...")

    for condition in skip_conditions:
        try:
            result = subprocess.run(
                condition,
                shell=True,
                capture_output=True,
                text=True,
                executable="/bin/bash",
            )
            if result.returncode != 0:
                print(f"Skip condition failed: {condition}")
                return False
            print(f"Skip condition passed: {condition}")
        except subprocess.CalledProcessError:
            print(f"Skip condition failed: {condition}")
            return False

    return True


def install_package(package_name: str):
    print("=" * 50)
    print(f"Installing package: {package_name}")
    print("=" * 50)

    package_info = get_package_info(package_name)

    depends_on_packages = get_package_info(package_name).get("depends_on", [])
    print(f"Dependent setups: {depends_on_packages}")
    for pkg in depends_on_packages:
        install_package(pkg)

    # Check if we should skip installation
    if check_skip_conditions(package_info):
        print(f"⏭ Skipping package '{package_name}' - all skip conditions are met")
        print()
        return

    commands = package_info.get(os_type, [])

    if not commands:
        print(f"No commands found for package '{package_name}' on OS '{os_type}'")
        sys.exit(1)
        return

    for cmd in commands:
        print(f"Executing: {cmd}")
        try:
            subprocess.run(cmd, shell=True, check=True, executable="/bin/bash")
        except subprocess.CalledProcessError:
            print(
                f"Failed to execute command for package '{package_name}': {cmd}",
                file=sys.stderr,
            )
            sys.exit(1)

    print(f"✓ Package '{package_name}' installed successfully")
    print()


def main():
    if len(sys.argv) < 2:
        print(
            "Usage: python3 packages/package.py PACKAGE1 PACKAGE2 ...", file=sys.stderr
        )
        print("\nExample: python3 packages/package.py git neovim", file=sys.stderr)
        sys.exit(1)

    packages = sys.argv[1:]

    print(f"Detected OS: {os_type}")
    print(f"Packages to install: {', '.join(packages)}")
    print()

    for pkg in packages:
        install_package(pkg)

    print("=" * 50)
    print("All packages installed successfully!")
    print("=" * 50)


if __name__ == "__main__":
    main()
