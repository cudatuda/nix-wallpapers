rec {
  # recursively process directory tree
  processImages =
    dir:
    let
      contents = builtins.readDir dir;

      mapContents =
        name: type:
        if type == "directory" then
          processImages "${dir}/${name}"
        else if type == "regular" && name != "README.md" then
          builtins.path {
            path = "${dir}/${name}";
            name = builtins.head (builtins.split "\\." name);
          }
        else
          null;

      makeAttrs =
        name: type:
        if type == "regular" && name != "README.md" then
          {
            name = builtins.head (builtins.split "\\." name);
            value = mapContents name type;
          }
        else
          {
            inherit name;
            value = mapContents name type;
          };

      # filter and create attribute set
      attrs = builtins.listToAttrs (
        builtins.filter (item: item.value != null) (
          builtins.map (name: makeAttrs name contents.${name}) (builtins.attrNames contents)
        )
      );
    in
    attrs;
}
