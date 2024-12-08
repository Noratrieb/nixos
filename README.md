# nixos config

## known bugs:
- $TMP pointing to a non-existing directory with direnv: https://github.com/direnv/direnv/issues/1345
  broke because of a nix update, probably because direnv is using nix shell weirdly