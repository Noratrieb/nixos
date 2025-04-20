{ pkgs, lib, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    mutableExtensionsDir = false;
    profiles.default = {
      enableUpdateCheck = false;
      keybindings = [
        {
          key = "ctrl+[BracketLeft]";
          command = "workbench.action.terminal.focus";
          when = "terminalProcessSupported";
        }
      ];
      userSettings = {
        # Note: In settings.json, `.` in a key is not equivalent to a nested object property.
        # Language-specific
        "rust-analyzer.server.path" = lib.getExe' pkgs.rustup "rust-analyzer";
        "[nix]"."editor.formatOnSave" = true;
        "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${lib.getExe pkgs.nil}";
        "nix.serverSettings" = {
          nil = {
            formatting = {
              command = [ "${lib.getExe pkgs.nixpkgs-fmt}" ];
            };
          };
        };
        "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[json]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[jsonc]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[html]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[css]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[typescriptreact]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        # Generic
        "window.zoomLevel" = 1;
        "terminal.integrated.enableMultiLinePasteWarning" = false;
        "git.confirmSync" = false;
        "debug.allowBreakpointsEverywhere" = false;
        # "editor.fontFamily" = "'Monaspace Neon Var', Arial";
        "editor.fontLigatures" = true;
        "terminal.integrated.scrollback" = 5000;
      };
      extensions = with pkgs.vscode-extensions; [
        bmalehorn.vscode-fish
        dbaeumer.vscode-eslint
        eamodio.gitlens
        esbenp.prettier-vscode
        github.vscode-github-actions
        golang.go
        hashicorp.terraform
        jnoortheen.nix-ide
        timonwong.shellcheck
        mads-hartmann.bash-ide-vscode
        ms-azuretools.vscode-docker
        ms-python.python
        ms-vscode-remote.remote-ssh
        ms-vscode.cmake-tools
        ms-vscode.cpptools
        ms-vscode.hexeditor
        myriad-dreamin.tinymist
        redhat.vscode-yaml
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        tomoki1207.pdf
        usernamehw.errorlens
        vadimcn.vscode-lldb
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          publisher = "dtsvet";
          name = "vscode-wasm";
          version = "1.4.1";
          sha256 = "sha256-zs7E3pxf4P8kb3J+5zLoAO2dvTeepuCuBJi5s354k0I=";
        }
        {
          publisher = "redhat";
          name = "ansible";
          version = "2.7.98";
          sha256 = "sha256-b3Z40IeQbtYci2LA4/OlJkfqMB78cWRNTNWd89lfhy4=";
        }
        {
          publisher = "matthewpi";
          name = "caddyfile-support";
          version = "0.3.0";
          sha256 = "sha256-1yiOnvC2w33kiPRdQYskee38Cid/GOj9becLadP1fUY=";
        }
        {
          publisher = "evan-buss";
          name = "font-switcher";
          version = "4.1.0";
          sha256 = "sha256-KkXUfA/W73kRfs1TpguXtZvBXFiSMXXzU9AYZGwpVsY=";
        }
        {
          publisher = "polymeilex";
          name = "wgsl";
          version = "0.1.17";
          sha256 = "sha256-vGqvVrr3wNG6HOJxOnJEohdrzlBYspysTLQvWuP0QIw=";
        }
        {
          publisher = "sunshaoce";
          name = "risc-v";
          version = "1.158.12";
          sha256 = "sha256-+HLAkxU9hIhP8tn0jVI2L2HcYusmHSpoaG7dHA7WgxA=";
        }
      ] ++ [
        ((pkgs.vscode-utils.buildVscodeExtension {
          pname = "riverdelta";
          version = "0.1.0";
          src = builtins.fetchGit {
            url = "https://github.com/Noratrieb/riverdelta";
            rev = "64d81b56084d9a7663517b367b4533fb8ea83a92";
          };
          vscodeExtPublisher = "Noratrieb";
          vscodeExtName = "riverdelta";
          vscodeExtUniqueId = "Noratrieb.riverdelta";
          buildPhase = ''
            runHook preBuild;
            cd ./vscode
            runHook postBuild;
          '';
        }).overrideAttrs
          (_: { sourceRoot = null; }))
      ];
    };

  };
}
