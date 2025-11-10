import sys
import subprocess
import yaml
from pathlib import Path
from typing import Dict, List, Set


def get_package_info(package_name: str) -> Dict:
    """Get package information including dependencies and commands."""
    script_dir = Path(__file__).parent
    package_file = script_dir / f"{package_name}.yaml"

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


def install_package(package_name: str, os_type: str):
    """Install a single package by executing its commands."""
    print("=" * 50)
    print(f"Installing package: {package_name}")
    print("=" * 50)

    package_info = get_package_info(package_name)
    commands = package_info.get(os_type, [])

    if not commands:
        print(f"No commands found for package '{package_name}' on OS '{os_type}'")
        sys.exit(1)
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
    """Main CLI entry point."""
    import platform

    if len(sys.argv) < 2:
        print(
            "Usage: python3 packages/package.py PACKAGE1 PACKAGE2 ...", file=sys.stderr
        )
        print("\nExample: python3 packages/package.py git neovim", file=sys.stderr)
        sys.exit(1)

    # Get package names from command line arguments
    packages = sys.argv[1:]

    # Detect OS type
    os_name = platform.system().lower()
    if "linux" in os_name:
        # Try to detect specific distro
        try:
            with open("/etc/os-release") as f:
                os_release = f.read().lower()
                if "ubuntu" in os_release or "debian" in os_release:
                    os_type = "ubuntu"
                elif "arch" in os_release:
                    os_type = "arch"
                else:
                    os_type = "ubuntu"  # Default to ubuntu
        except:
            os_type = "ubuntu"  # Default fallback
    else:
        os_type = os_name

    print(f"Detected OS: {os_type}")
    print(f"Packages to install: {', '.join(packages)}")
    print()

    # Resolve dependencies
    install_order = resolve_dependencies(packages)

    print(f"Installation order (with dependencies): {' -> '.join(install_order)}")
    print()

    # Install packages in order
    for package in install_order:
        install_package(package, os_type)

    print("=" * 50)
    print("All packages installed successfully!")
    print("=" * 50)


if __name__ == "__main__":
    main()
