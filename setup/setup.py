import sys
import subprocess
import yaml
from pathlib import Path
from typing import Dict

sys.path.append(str(Path(__file__).parent.parent))
from distros.distro import get_os_type
from packages.package import install_package

os_type = get_os_type()


def get_setup_data(setup_name: str) -> Dict:
    setup_file = Path("setup") / f"{setup_name}.yaml"

    if not setup_file.exists():
        print(f"Setup file not found: {setup_file}", file=sys.stderr)
        sys.exit(1)

    with open(setup_file) as f:
        data = yaml.safe_load(f)

    return data.get("setup", {})


def run_preparation_steps(setup_name: str):
    prep_steps = get_setup_data(setup_name).get("preparation-steps", [])

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


def install_setup(setup_name: str):
    print("=" * 50)
    print(f"Running setup: {setup_name}")
    print("=" * 50)
    print()

    depends_on_setup = get_setup_data(setup_name).get("depends_on", [])
    print(f"Dependent setups: {depends_on_setup}")
    for dep_setup in depends_on_setup:
        install_setup(dep_setup)

    run_preparation_steps(setup_name)

    for pkg in get_setup_data(setup_name).get("packages", []):
        install_package(pkg)

    print("=" * 50)
    print(f"✓ Setup '{setup_name}' completed successfully!")
    print("=" * 50)


def main():
    if len(sys.argv) < 2:
        print("Usage: ./setup.py <setup-name>", file=sys.stderr)
        print("Example: ./setup.py base", file=sys.stderr)
        sys.exit(1)

    print("=" * 50)
    print(f"OS type: {os_type}")
    print("=" * 50)

    setup_name = sys.argv[1]
    install_setup(setup_name)


if __name__ == "__main__":
    main()
