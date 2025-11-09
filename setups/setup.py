# Ubuntu
# sudo apt install -y python3-yaml

# Arch
# sudo pacman -S --noconfirm python python-yaml

import sys
import subprocess
import yaml
from pathlib import Path
from typing import Dict, List, Set

from packages.package import get_package_info, resolve_dependencies, install_package


def get_os_type() -> str:
    """Determine the OS type (ubuntu or arch)."""
    os_release_file = Path("/etc/os-release")

    if not os_release_file.exists():
        print("Cannot determine OS type", file=sys.stderr)
        sys.exit(1)

    os_release = {}
    with open(os_release_file) as f:
        for line in f:
            line = line.strip()
            if "=" in line:
                key, value = line.split("=", 1)
                os_release[key] = value.strip('"').strip("'")

    os_id = os_release.get("ID", "").lower()

    if os_id in ["ubuntu", "debian"]:
        return "ubuntu"
    elif os_id in ["arch", "manjaro"]:
        return "arch"
    else:
        print(f"Unsupported OS: {os_id}", file=sys.stderr)
        sys.exit(1)


def get_setup_data(setup_name: str) -> Dict:
    """Get the setup data from a setup file."""
    setup_file = Path("setups") / f"{setup_name}.yaml"

    if not setup_file.exists():
        print(f"Setup file not found: {setup_file}", file=sys.stderr)
        sys.exit(1)

    with open(setup_file) as f:
        data = yaml.safe_load(f)

    return data.get("setup", {})


def get_setup_packages(setup_name: str) -> List[str]:
    """Get the list of packages from a setup file."""
    setup_data = get_setup_data(setup_name)
    return setup_data.get("packages", [])


def get_preparation_steps(setup_name: str) -> List[str]:
    """Get the preparation steps from a setup file."""
    setup_data = get_setup_data(setup_name)
    return setup_data.get("preparation-steps", [])


def get_setup_dependencies(setup_name: str) -> List[str]:
    """Get the list of setup dependencies from a setup file."""
    setup_data = get_setup_data(setup_name)
    return setup_data.get("depends_on", [])


def run_preparation_steps(setup_name: str):
    """Run preparation steps before installing packages."""
    prep_steps = get_preparation_steps(setup_name)

    if not prep_steps:
        return

    print("=" * 50)
    print("Running preparation steps")
    print("=" * 50)

    for cmd in prep_steps:
        print(f"Executing: {cmd}")
        try:
            subprocess.run(cmd, shell=True, check=True, executable="/bin/bash")
        except subprocess.CalledProcessError as e:
            print(f"Failed to execute preparation step: {cmd}", file=sys.stderr)
            sys.exit(1)

    print("✓ Preparation steps completed successfully")
    print()


def run_setup(setup_name: str, os_type: str, processed_setups: Set[str], installed_packages: Set[str]):
    """
    Run a setup, including its dependencies.
    Uses sets to track processed setups and installed packages to avoid duplicates.
    """
    # Check if already processed
    if setup_name in processed_setups:
        print(f"Setup '{setup_name}' already processed, skipping...")
        return

    print("=" * 50)
    print(f"Processing setup: {setup_name}")
    print("=" * 50)
    print()

    # Get and process setup dependencies first
    setup_dependencies = get_setup_dependencies(setup_name)
    if setup_dependencies:
        print(f"Setup '{setup_name}' depends on: {', '.join(setup_dependencies)}")
        print()
        for dep_setup in setup_dependencies:
            run_setup(dep_setup, os_type, processed_setups, installed_packages)

    # Get packages from setup
    packages = get_setup_packages(setup_name)

    if not packages:
        print(f"No packages found in setup: {setup_name}")
        processed_setups.add(setup_name)
        return

    print(f"Packages to install for '{setup_name}':")
    for pkg in packages:
        print(f"  - {pkg}")
    print()

    # Run preparation steps
    run_preparation_steps(setup_name)

    # Resolve dependencies and get install order
    install_order = resolve_dependencies(packages)

    # Filter out already installed packages
    packages_to_install = [pkg for pkg in install_order if pkg not in installed_packages]

    if not packages_to_install:
        print("All packages already installed, skipping...")
    else:
        print("Installation order (with dependencies, excluding already installed):")
        for pkg in packages_to_install:
            print(f"  - {pkg}")
        print()

        # Install packages
        for package in packages_to_install:
            install_package(package, os_type)
            installed_packages.add(package)

    # Mark as processed
    processed_setups.add(setup_name)

    print("=" * 50)
    print(f"✓ Setup '{setup_name}' completed successfully!")
    print("=" * 50)
    print()


def main():
    """Main function."""
    if len(sys.argv) < 2:
        print("Usage: ./setup.py <setup-name>", file=sys.stderr)
        print("Example: ./setup.py base", file=sys.stderr)
        sys.exit(1)

    setup_name = sys.argv[1]
    os_type = get_os_type()

    print("=" * 50)
    print(f"Starting setup: {setup_name}")
    print(f"OS type: {os_type}")
    print("=" * 50)
    print()

    # Track processed setups and installed packages to avoid duplicates
    processed_setups: Set[str] = set()
    installed_packages: Set[str] = set()

    # Run the setup and all its dependencies
    run_setup(setup_name, os_type, processed_setups, installed_packages)

    print("=" * 50)
    print(f"✓ All setups completed successfully!")
    print("=" * 50)


if __name__ == "__main__":
    main()
