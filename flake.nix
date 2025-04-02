{
  description = "Flake that provides wallpapers as an attribute set";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    git-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      git-hooks,
    }:
    let
      lib = import ./lib.nix;
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs { inherit system; };
          }
        );
    in
    {
      wallpapers = lib.processImages ./wallpapers;
    }
    // forEachSupportedSystem (
      { pkgs }:
      let
        pre-commit-lib = git-hooks.lib.${pkgs.system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            bash
            findutils
            rename
            git
          ];
          inherit (self.checks.${pkgs.system}.pre-commit-check) shellHook;
        };

        checks.pre-commit-check = pre-commit-lib.run {
          src = ./.;
          hooks = {
            rename-wallpapers = {
              enable = true;
              name = "rename-wallpapers";
              entry = "${lib.mkRenameImagesScript pkgs}";
              files = "^wallpapers/.*\\.(png|jpg|jpeg)$";
              pass_filenames = false;
              stages = [ "pre-commit" ];
            };
          };
        };
      }
    );
}
