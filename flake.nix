{
  description = "Flake that provides structured wallpapers";

  outputs =
    _:
    let
      removeExtension =
        filename:
        let
          parts = builtins.split "\\." filename;
        in
        if builtins.length parts > 1 then builtins.elemAt parts 0 else filename;

      createWallpapers =
        path:
        let
          contents = builtins.readDir path;

          processEntry =
            name: type:
            if type == "directory" then
              createWallpapers (path + "/${name}")
            else if type == "regular" && name != "README.md" then
              builtins.path {
                path = path + "/${name}";
                name = removeExtension name;
              }
            else
              null;

          entries = builtins.listToAttrs (
            builtins.map
              (name: {
                name = if contents.${name} == "regular" && name != "README.md" then removeExtension name else name;
                value = processEntry name contents.${name};
              })
              (builtins.filter (name: processEntry name contents.${name} != null) (builtins.attrNames contents))
          );
        in
        entries;
    in
    {
      wallpapers = createWallpapers ./wallpapers;
    };
}
