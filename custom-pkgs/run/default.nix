{ pkgs ? import <nixpkgs> { } }: pkgs.writeShellScriptBin "run" ''
  first="$1"
  if [ -z "$first" ]; then
    echo "error: must provide package name"
    exit 1
  fi
  shift
  export NIXPKGS_ALLOW_UNFREE=1
  nix run --impure nixpkgs#"$first" -- "$@"
''
