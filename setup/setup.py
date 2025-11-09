import sys
import subprocess
import yaml
from pathlib import Path
from typing import Dict, List, Set

# Add the parent directory to Python path to allow imports
sys.path.append(str(Path(__file__).parent.parent))
from distros.distro import get_os_type

def get_setup_data(setup_name: str) -> Dict:
    """Get the setup data from a setup file."""
    setup_file = Path("setup") / f"{setup_name}.yaml"

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


def get_package_info(package_name: str) -> Dict:
    """Get package information including dependencies and commands."""
    package_file = Path("packages") / f"{package_name}.yaml"

    if not package_file.exists():
        print(f"Package file not found: {package_file}", file=sys.stderr)
        sys.exit(1)

    with open(package_file) as f:
        data = yaml.safe_load(f)

    return data.get("package", {})


def resolve_dependencies(packages: List[str]) -> List[str]:
    """
    Resolve dependencies using topological sort.
    Returns packages in installation order.
    """
    visited: Set[str] = set()
    installing: Set[str] = set()
    install_order: List[str] = []

    def visit(package: str):
        if package in visited:
            return

        if package in installing:
            print(f"Circular dependency detected: {package}", file=sys.stderr)
            sys.exit(1)

        installing.add(package)

        # Get dependencies
        package_info = get_package_info(package)
        dependencies = package_info.get("depends_on", [])

        for dep in dependencies:
            visit(dep)

        installing.remove(package)
        visited.add(package)
        install_order.append(package)

    for package in packages:
        visit(package)

    return install_order


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


def install_package(package_name: str, os_type: str):
    """Install a single package by executing its commands."""
    print("=" * 50)
    print(f"Installing package: {package_name}")
    print("=" * 50)

    package_info = get_package_info(package_name)
    commands = package_info.get(os_type, [])

    if not commands:
        print(f"No commands found for package '{package_name}' on OS '{os_type}'")
        return

    for cmd in commands:
        print(f"Executing: {cmd}")
        try:
            # Execute command in shell
            result = subprocess.run(cmd, shell=True, check=True, executable="/bin/bash")
        except subprocess.CalledProcessError as e:
            print(
                f"Failed to execute command for package '{package_name}': {cmd}",
                file=sys.stderr,
            )
            sys.exit(1)

    print(f"✓ Package '{package_name}' installed successfully")
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
    print(f"Running setup: {setup_name}")
    print(f"OS type: {os_type}")
    print("=" * 50)
    print()

    # Get packages from setup
    packages = get_setup_packages(setup_name)

    if not packages:
        print(f"No packages found in setup: {setup_name}", file=sys.stderr)
        sys.exit(1)

    print("Packages to install:")
    for pkg in packages:
        print(f"  - {pkg}")
    print()

    # Run preparation steps first
    run_preparation_steps(setup_name)

    # Resolve dependencies and get install order
    install_order = resolve_dependencies(packages)

    print("Installation order (with dependencies):")
    for pkg in install_order:
        print(f"  - {pkg}")
    print()

    # Install packages
    for package in install_order:
        install_package(package, os_type)

    print("=" * 50)
    print(f"✓ Setup '{setup_name}' completed successfully!")
    print("=" * 50)


if __name__ == "__main__":
    main()
