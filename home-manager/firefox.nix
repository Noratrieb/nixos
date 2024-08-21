{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    # see configuration.nix
    package = pkgs.firefox-beta;
    profiles = {
      nils = {
        id = 0;
        name = "nils";

        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          tampermonkey
          sidebery
          darkreader
        ];

        bookmarks = [
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
            ];
          }
        ];
      };
    };
  };
}
