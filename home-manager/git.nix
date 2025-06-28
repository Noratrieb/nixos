{ pkgs, lib, ... }: {
  programs.git = {
    enable = true;

    userEmail = "48135649+Noratrieb@users.noreply.github.com";
    userName = "Noratrieb";

    aliases = {
      # simple aliases
      c = "checkout";
      st = "status";
      p = "push";
      rc = "rebase --continue";
      ra = "rebase --abort";
      amend = "commit --amend --no-edit";
      # complex renames
      hardupdate = "!git fetch && git reset --hard \"origin/$(git rev-parse --abbrev-ref HEAD)\"";
      fpush = "push --force-with-lease";
      resq = "rebase --autosquash -i";
      autosquash = "!${lib.getExe pkgs.git-revise} -i $(git merge-base HEAD origin/HEAD) --autosquash";
      autosq = "autosquash";
      pfush = "!echo \"hör uf ume z'pfusche und machs richtig\"";
      sw = "!git checkout $(git branch --format \"%(refname:lstrip=2)\" | ${lib.getExe' pkgs.fzf "fzf"})";
      # lol
      build = "!cargo build";
    };
    difftastic = {
      enable = true;
    };
    extraConfig = {
      # TODO: See https://jvns.ca/blog/2024/02/16/popular-git-config-options
      core.autocrlf = false;
      core.editor = "${lib.getExe pkgs.neovim}";
      pull.ff = "only";
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      merge.conflictstyle = "zdiff3";

      # https://github.com/rust-lang/rust/blob/a83cf567b5949691de67f06895d9fe0404c40d27/.git-blame-ignore-revs
      # doesn't work cause lol its an error to not have the file
      # blame.ignoreRevsFile = ".git-blame-ignore-revs";

      # This makes it so that pushing always uses SSH, even if the remote was configured as HTTPS.
      "url \"git@github.com:\"".pushInsteadOf = "https://github.com/";
      "url \"git@gitlab.com:\"".pushInsteadOf = "https://gitlab.com/";
      "url \"git@gist.github.com:\"".pushInsteadOf = "https://gist.github.com/";
    };
  };
}
