{ pkgs, ... }: pkgs.writeShellApplication {
  name = "expbrightness";
  runtimeInputs = [ pkgs.bc pkgs.brightnessctl ];
  text = ''
    cur=$(brightnessctl get)

    case "$1" in
      up)
        if [[ "$cur" -lt 5 ]]; then
          # because 1.3*0=0
          value=5
        else
          value=$(printf '%s * 13 / 10\n' "$cur" | bc)
        fi
        ;;
      down)
        value=$(printf 'scale=0; %s / 1.3\n' "$cur" | bc)
        ;;
      *)
        echo "Usage: $0 {up|down}" >&2
        exit 2
        ;;
    esac

    brightnessctl set "$value"
  '';
}
