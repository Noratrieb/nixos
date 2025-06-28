{ pkgs, lib }: pkgs.writeShellApplication {
  name = "regenerate-bsod-lockscreen";
  text = ''
    echo "Regenerating the lock screen..."
    stopcode=$(shuf -n 1 < "${./codes.txt}")
    percent=$(shuf -i 0-101 -n1)
    ${lib.getExe pkgs.typst} compile --input "stopcode=$stopcode" --input "percent=$percent" --font-path ${./fonts} ${./bsod.typ} --format png --ppi 200 "/run/user/$(id -u)/lockscreen.png"
  '';
}
