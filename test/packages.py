import os
import subprocess
from pathlib import Path
from typing import Generator

import pytest


def get_all_package_files(base_path: Path) -> Generator[Path, None, None]:
    for root, _, files in os.walk(base_path):
        for file in files:
            if file.endswith("." + "yaml"):
                yield Path(os.path.join(root, file))


def packages_standalone(file_name: Path, distro: str) -> None:
    """Test package installation in Docker container."""
    # Extract package name from file path (remove .yaml extension)
    package_name = file_name.stem

    # Build Docker image if needed
    image_name = "packages_test"
    dockerfile_path = f"./docker/{distro}.Dockerfile"
    username = "ak"

    print(f"\nTesting package: {package_name}")

    # Remove old image (ignore errors if it doesn't exist)
    subprocess.run(
        ["docker", "image", "rm", image_name, "--force"],
        capture_output=True,
        timeout=30,
    )

    # Build Docker image
    print(f"Building Docker image from {dockerfile_path}...")
    build_result = subprocess.run(
        [
            "docker",
            "build",
            "-f",
            dockerfile_path,
            "--build-arg",
            f"USERNAME={username}",
            "--target",
            "test",
            "-t",
            image_name,
            ".",
        ],
        capture_output=True,
        text=True,
        timeout=300,  # 5 minute timeout for build
    )

    if build_result.returncode != 0:
        pytest.fail(
            f"Docker build failed for {package_name}:\n"
            f"STDOUT: {build_result.stdout}\n"
            f"STDERR: {build_result.stderr}"
        )

    # Run package installation in container
    print(f"Running package installation for {package_name}...")
    run_result = subprocess.run(
        [
            "docker",
            "run",
            "--rm",
            image_name,
            "bash",
            "-c",
            f"cd /home/{username}/dotfiles && ./bootstrap.sh && python3 ./packages/package.py {package_name}",
        ],
        capture_output=True,
        text=True,
        timeout=600,  # 10 minute timeout for package installation
    )

    # Clean up image after test
    subprocess.run(
        ["docker", "image", "rm", image_name, "--force"],
        capture_output=True,
        timeout=30,
    )

    # Assert that the package installation succeeded
    if run_result.returncode != 0:
        pytest.fail(
            f"Package '{package_name}' installation failed in Docker:\n"
            f"STDOUT: {run_result.stdout[:-300]}\n"
            f"STDERR: {run_result.stderr}"
        )

    print(f"✓ Package '{package_name}' installed successfully")


@pytest.mark.parametrize(
    "file_name",
    list(get_all_package_files(Path("./packages"))),
    ids=lambda p: str(p),
)
def test_packages_standalone_arch(file_name: Path) -> None:
    packages_standalone(file_name, "Arch")


@pytest.mark.parametrize(
    "file_name",
    list(get_all_package_files(Path("./packages"))),
    ids=lambda p: str(p),
)
def test_packages_standalone_ubuntu(file_name: Path) -> None:
    packages_standalone(file_name, "Ubuntu")
