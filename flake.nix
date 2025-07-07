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
            system = system;
          }
        );
    in
    {
      wallpapers = lib.processImages ./wallpapers;

      devShells = forEachSupportedSystem (
        { pkgs, system }:
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              bash
              findutils
              rename
              git
            ];
            inherit (self.checks.${system}.pre-commit-check) shellHook;
          };
        }
      );

      checks = forEachSupportedSystem (
        { pkgs, system }:
        {
          pre-commit-check = git-hooks.lib.${system}.run {
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
    };

}
