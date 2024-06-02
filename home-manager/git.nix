{ pkgs, lib, ... }: {
  programs.git = {
    enable = true;

    userEmail = "48135649+Nilstrieb@users.noreply.github.com";
    userName = "Nilstrieb";

    aliases = {
      # simple aliases
      st = "status";
      rc = "rebase --continue";
      ra = "rebase --abort";
      # complex renames
      # TODO: use git-revise
      hardupdate = "!git fetch && git reset --hard \"origin/$(git rev-parse --abbrev-ref HEAD)\"";
      fpush = "push --force-with-lease";
      resq = "rebase --autosquash -i";
      pfush = "!echo \"hör uf ume z'pfusche und machs richtig\"";
      sw = "!git checkout $(git branch --format \"%(refname:lstrip=2)\" | ${lib.getExe' pkgs.fzf "fzf"})";
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
      blame.ignoreRevsFile = ".git-blame-ignore-revs";

      # This makes it so that pushing always uses SSH, even if the remote was configured as HTTPS.
      "url \"git@github.com:\"".pushInsteadOf = "https://github.com/";
      "url \"git@gitlab.com:\"".pushInsteadOf = "https://gitlab.com/";
      "url \"git@gist.github.com:\"".pushInsteadOf = "https://gist.github.com/";
    };
  };
}
