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

  mkRenameImagesScript =
    pkgs:
    pkgs.writeShellScript "rename-images" ''
      set -e
      git diff --cached --name-only --diff-filter=ACM | grep '^wallpapers/.*\.\(png\|jpg\|jpeg\)$' | while read -r file; do
        dir=$(dirname "$file")
        base=$(basename "$file")
        new_base=$(echo "$base" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
        if [ "$base" != "$new_base" ]; then
          if [ -e "$dir/$new_base" ]; then
            echo "Error: '$dir/$new_base' already exists, skipping rename of '$file'"
          else
            mv -v "$file" "$dir/$new_base"
            git rm -f --cached "$file"
            git add "$dir/$new_base"
          fi
        fi
      done
    '';
}
