{ pkgs, config, ... }: {
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    policies = {
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
    };
    profiles = {
      nora = {
        id = 0;
        name = "nora";

        search = {
          force = true;
          default = "ddg";

          engines = let disabled = [ "bing" "ebay" "ecosia" "perplexity" "qwant" ]; in
            builtins.listToAttrs (map
              (
                name: { inherit name; value = { metaData.hidden = true; }; }
              )
              disabled);

          order = [ "ddg" "wikipedia" "google" ];
        };

        userChrome = ''
          /* hides the native tabs */
          #TabsToolbar {
            visibility: collapse;
          }
        '';

        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };

        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          tampermonkey
          sidebery
          darkreader
          sponsorblock
        ];

        bookmarks = {
          force = true;
          settings = [
            {
              name = "Nix sites";
              toolbar = true;
              bookmarks = [
                {
                  name = "NixOS options";
                  url = "https://search.nixos.org/options";
                }
                {
                  name = "home-manager options";
                  url = "https://rycee.gitlab.io/home-manager/options.xhtml";
                }
                {
                  name = "nixpkgs search";
                  url = "https://search.nixos.org/packages";
                }
                {
                  name = "Github Notifications";
                  url = "https://github.com/notifications";
                }
                {
                  name = "glove80 layout";
                  url = "https://my.moergo.com/glove80/#/layout/user/4ade12f3-81d7-4342-8196-9c13c43ac94e";
                }
              ];
            }
          ];
        };
      };
    };
  };
}
