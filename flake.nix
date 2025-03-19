{
  description = "Flake that provides wallpapers as an attribute set";

  outputs =
    _:
    let
      lib = import ./lib.nix;
    in
    {
      wallpapers = lib.processImages ./wallpapers;
    };
}
