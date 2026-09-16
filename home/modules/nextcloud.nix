# Nextcloud over WebDAV, streamed -- lab holds the files, this box holds none.
# The app password is the one thing the repo cannot carry: it sits in
# ~/.config/rclone/nextcloud-app-password (0600) and every unit here is inert
# without it, which is also what keeps WSL quiet.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  mountPoint = "${config.home.homeDirectory}/Nextcloud";
  secret = "${config.xdg.configHome}/rclone/nextcloud-app-password";

  # A SIGKILLed rclone leaves "Transport endpoint is not connected" behind and
  # the next start trips over it, so this runs both on the way in and on the way
  # out. /usr/bin/fusermount3, not ${pkgs.fuse3}: it has to be the setuid one.
  # $1 is the mode for the dir underneath: 0755 in (fusermount3 refuses a
  # mountpoint the user cannot write), 0555 out.
  reset = pkgs.writeShellScript "nextcloud-reset-mountpoint" ''
    set -u
    mode="$1"
    /usr/bin/fusermount3 -uz ${mountPoint} 2>/dev/null || true
    ${pkgs.coreutils}/bin/mkdir -p ${mountPoint}
    # never on a non-empty dir: 0555 over the old sync folder would only make it
    # harder to delete
    if [ -z "$(${pkgs.coreutils}/bin/ls -A ${mountPoint} 2>/dev/null)" ]; then
      ${pkgs.coreutils}/bin/chmod "$mode" ${mountPoint}
    fi
  '';
in
{
  programs.rclone = {
    enable = true;

    remotes.nextcloud = {
      config = {
        type = "webdav";
        # no trailing slash, and /dav/files/<user> exactly: the nextcloud
        # vendor refuses anything else, chunked uploads depend on it
        url = "http://lab:8080/remote.php/dav/files/ak";
        vendor = "nextcloud";
        user = "ak";
      };

      # read by rclone-config.service at start, never at eval time
      secrets.pass = secret;

      # "" -> the whole account, i.e. `rclone mount nextcloud: ~/Nextcloud`
      mounts."" = {
        enable = true;
        inherit mountPoint;
        options = {
          # `writes`, not the module default `full`: reads stream straight off
          # lab, and only a file opened for writing is staged -- into %t,
          # /run/user/1000, a tmpfs, so even that never reaches the SSD.
          vfs-cache-mode = "writes";
          cache-dir = "%t/rclone";
          vfs-cache-max-age = "1h";
          # ceilings on RAM, not on disk: /run/user/1000 is a 3.1G tmpfs shared
          # with the rest of the session.
          vfs-cache-max-size = "1G";
          vfs-cache-min-free-space = "512M";

          # `rclone backend features` on this server reports ChangeNotify:false
          # -- WebDAV cannot push changes, so the dir cache is the *only* thing
          # deciding how stale a listing gets. 5m: a file added from the phone
          # shows up within five minutes, a unit restart forces it sooner.
          # poll-interval 0 silences the "not supported" line at every start.
          dir-cache-time = "5m";
          poll-interval = "0";

          # a music library over LAN: bigger reads, fewer round trips
          vfs-read-chunk-size = "32M";
          vfs-read-chunk-size-limit = "256M";
          buffer-size = "32M";

          # lab off the network: fail in seconds instead of hanging Nautilus.
          # --timeout (IO idle) stays at its 5m default -- a chunked Nextcloud
          # upload can legitimately go quiet while the server assembles it.
          contimeout = "10s";
          low-level-retries = 3;

          umask = "022";
          log-systemd = true;
        };
      };
    };
  };

  # No app password -> nothing to render and nothing to mount. A condition
  # *skips* both units; failing them would leave two red units on every WSL box.
  systemd.user.services = {
    rclone-config.Unit.ConditionPathExists = secret;

    "rclone-mount:@nextcloud" = {
      Unit = {
        ConditionPathExists = secret;
        # a laptop away from home has to keep trying, not give up after 5 goes
        StartLimitIntervalSec = 0;
      };
      Service = {
        RestartSec = "30s";
        # mkForce: the module sets this to a bare string, and
        # `either primitive (listOf primitive)` cannot merge a string with a
        # list. `reset` does the mkdir the original did, and more.
        ExecStartPre = lib.mkForce [ "-${reset} 0755" ];
        # runs on a crash too, so a stale endpoint never outlives the unit
        ExecStopPost = "-${reset} 0555";
      };
    };
  };

  # localsearch indexes $HOME recursively and a FUSE mount looks local to it, so
  # without this it crawls the whole library over the network at every login.
  # The list is replaced wholesale, hence the upstream defaults carried along.
  dconf.settings."org/freedesktop/tracker/miner/files".ignored-directories = [
    "po"
    "CVS"
    "core-dumps"
    "lost+found"
    mountPoint
  ];

  # An unmounted ~/Nextcloud must not quietly collect files on the SSD, so the
  # dir underneath the mount is left read-only; the mount unit chmods it back.
  # Empty-only, so this is safe to run while the old sync folder is still there.
  home.activation.nextcloudMountPoint = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mp="${mountPoint}"
    if ! /usr/bin/mountpoint -q "$mp"; then
      run mkdir -p "$mp"
      if [ -z "$(ls -A "$mp" 2>/dev/null)" ]; then
        run chmod 0555 "$mp"
      fi
    fi
  '';
}
