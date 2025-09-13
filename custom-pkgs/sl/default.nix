{ pkgs, ... }: pkgs.writeShellApplication {
  name = "sl";
  runtimeInputs = with pkgs; [ niri jq ];
  derivationArgs = {
    # shellcheck can't comprehend our amazingly new bash syntax
    checkPhase = null;
  };
  text = builtins.readFile ./sl.sh;
}
