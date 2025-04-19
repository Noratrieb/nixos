{ pkgs, ... }: pkgs.writeShellApplication {
  name = "u";

  text = ''
    programs=(cargo git)

    if [ -z "''${1:-}" ]; then
      echo "u: universial command executor"
      echo "programs: ''${programs[*]}"
      exit 0
    fi

    program_to_use=""

    for program in "''${programs[@]}"; do
      if PAGER=true "$program" "$1" --help >/dev/null 2>/dev/null; then
        if [ -n "$program_to_use" ]; then
          echo "u: conflict: $1 is provided by both $program_to_use and $program" >&2
          exit 1
        fi
        program_to_use="$program"
      fi
    done

    if [ -n "$program_to_use" ]; then
      exec "$program_to_use" "$@"
    fi

    echo "error: cannot find program for $1" >&2
    exit 1
  '';
}
