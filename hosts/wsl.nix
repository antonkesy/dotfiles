# Ubuntu on WSL2: terminal and toolchains only. Needs systemd=true in
# /etc/wsl.conf for the user services (../setup's wsl role writes it).
{ ... }:
{
  ak = {
    wsl = true;
    development.enable = true;
    containers.enable = true;
  };
}
