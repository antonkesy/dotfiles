# NAS shares over SMB. The fstab entries (noauto,user) come from the Arch storage
# role; this only drives the lifecycle -- mounted with the graphical session, gone
# at logout. /usr/bin/mount is setuid root, so ak may mount them and mount.cifs
# reads the root-only credentials file on his behalf.
{ lib, pkgs, ... }:
let
  host = "192.168.178.26";
  root = "/mnt/nas";
  shares = [
    "Music"
    "Movies"
    "ak"
  ];
  credentials = "/etc/nas/credentials";

  # A dead NAS -- or a laptop on a foreign network -- must never stall the session.
  mountScript = pkgs.writeShellScript "nas-mount" ''
    set -u

    if ! ${pkgs.coreutils}/bin/timeout 3 \
        ${pkgs.bash}/bin/bash -c "exec 3<>/dev/tcp/${host}/445" 2>/dev/null; then
      echo "nas-mount: ${host}:445 unreachable, nothing mounted" >&2
      exit 0
    fi

    for share in ${lib.escapeShellArgs shares}; do
      target="${root}/$share"
      /usr/bin/mountpoint -q "$target" && continue
      mounted=0
      for _ in 1 2 3; do
        # the target, never //host/share: mount(8) is strict about non-root callers
        # and re-reads fstab for the options, which is also why ak cannot swap them
        if /usr/bin/mount "$target"; then
          mounted=1
          break
        fi
        ${pkgs.coreutils}/bin/sleep 2
      done
      [ "$mounted" -eq 1 ] || echo "nas-mount: giving up on $target" >&2
    done
  '';

  umountScript = pkgs.writeShellScript "nas-umount" ''
    set -u
    for share in ${lib.escapeShellArgs shares}; do
      target="${root}/$share"
      /usr/bin/mountpoint -q "$target" || continue
      # -l only bites when something still holds the mount open
      /usr/bin/umount "$target" || /usr/bin/umount -l "$target" || true
    done
  '';
in
{
  systemd.user.services.nas-mount = {
    Unit = {
      Description = "NAS SMB shares for this session";
      Documentation = [ "man:mount.cifs(8)" ];
      # /etc/nas is 0755 so this stat succeeds as ak; the file itself is 0600.
      # Also keeps the unit inert where the storage role never ran (WSL).
      ConditionPathExists = credentials;
      # PartOf, never Requires: graphical-session.target is RefuseManualStart
      # and StopWhenUnneeded, so a Requires would try to pull it up.
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      # `-`: a missing NAS must not leave the unit failed, or RemainAfterExit
      # never applies and ExecStop never runs.
      ExecStart = "-${mountScript}";
      ExecStop = "-${umountScript}";
      TimeoutStartSec = "90s";
      TimeoutStopSec = "30s";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
