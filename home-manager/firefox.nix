{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    profiles = {
      nora = {
        id = 0;
        name = "nora";

        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          tampermonkey
          sidebery
          darkreader
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
                  url = "https://rycee.gitlab.io/home-manager/options.html";
                }
                {
                  name = "nixpkgs search";
                  url = "https://search.nixos.org/packages";
                }
                {
                  name = "Github Notifications";
                  url = "https://github.com/notifications";
                }
              ];
            }
          ];
        };
      };
    };
  };
}
