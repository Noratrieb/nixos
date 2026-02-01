{ pkgs }: pkgs.writeShellApplication {
  name = "flash-glove80";
  text = builtins.readFile ./flash.sh;
}
