{
  description = "Flake that provides wallpapers as an attribute set";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    git-hooks.url = "github:cachix/git-hooks.nix";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      git-hooks,
      flake-utils,
    }:
    let
      lib = import ./lib.nix;
    in
    {
      wallpapers = lib.processImages ./wallpapers;
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pre-commit-lib = git-hooks.lib.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            bash
            findutils
            rename
            git
          ];
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        };

        checks.pre-commit-check = pre-commit-lib.run {
          src = ./.;
          hooks = {
            rename-wallpapers = {
              enable = true;
              name = "rename-wallpapers";
              entry = "${lib.mkRenameImagesScript pkgs}"; # Используем функцию из lib.nix
              files = "^wallpapers/.*\\.(png|jpg|jpeg)$";
              pass_filenames = false;
              stages = [ "pre-commit" ];
            };
          };
        };
      }
    );
}
