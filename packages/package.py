import sys
import subprocess
import yaml
from pathlib import Path
from typing import Dict, List, Set


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
