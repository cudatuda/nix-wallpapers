{
  description = "Flake that provides images";

  outputs = _: {
    wallpapers = builtins.path {
      path = ./wallpapers;
      name = "wallpapers";
      filter = path: type: baseNameOf path != "README.md";
    };
  };
}
