import sys
from pathlib import Path


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
