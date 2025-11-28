{ lib, pkgs, ... }: {
  systemd.services.paperless-ngx-backup = {
    description = "paperless-ngx data backup to NAS";
    serviceConfig = {
      Type = "oneshot";
      User = "nora";
      ExecStart = ''
        ${lib.getExe pkgs.rsync} -a -v --delete --exclude=redis /home/nora/.local/share/paperless-ngx/ /mnt/nas/HEY/_Nora/paperless/backup
      '';
    };
  };
  systemd.timers.paperless-ngx-backup = {
    description = "paperless-ngx data backup to NAS";
    wantedBy = [ "timers.target" ];
    after = [ "mnt-nas.mount" ];
    timerConfig = {
      Unit = "paperless-ngx-backup.service";
      OnCalendar = "daily UTC";
      RandomizedDelaySec = 1800;
      FixedRandomDelay = true;
      Persistent = true; # ensure it still runs if the computer was down at the timer of trigger
    };
  };
}
