{ lib, pkgs, ... }:
let localDir = "/home/nora/.local/share/paperless-ngx"; nasDir = "/mnt/nas/HEY/_Nora/paperless"; in {
  services.paperless = {
    enable = true;
    dataDir = "${localDir}/data";
    mediaDir = "${localDir}/media";
    consumptionDir = "${nasDir}/consume";
    address = "0.0.0.0";
    port = 8010;
    user = "nora";
    environmentFile = "${localDir}/secrets-environment";
    settings = {
      PAPERLESS_TIME_ZONE = "Europe/Zurich";
      PAPERLESS_ADMIN_USER = "nora";
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
    };
    exporter = {
      enable = true;
      directory = "${nasDir}/export";
    };
  };


  systemd.services.paperless-ngx-backup = {
    description = "paperless-ngx data backup to NAS";
    serviceConfig = {
      Type = "oneshot";
      User = "nora";
      ExecStart = ''
        ${lib.getExe pkgs.rsync} -a -v --delete --exclude=redis ${localDir}/ ${nasDir}/backup
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
