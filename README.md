# Nix Wallpapers
A Nix flake that provides structured access to wallpapers. This flake organizes wallpapers in a directory structure and makes them easily accessible through Nix attributes.
## Features
- Access wallpapers through a structured attribute set
- Supports nested directories for organization
- Attribute structure **exactly** mirrors the directory structure of images
- Easy to add new wallpapers
## Usage
`wallpapers`
1. Add this flake as an **input**:
    ```nix
    # flake.nix
    {
      inputs = {
        nix-wallpapers.url = "github:cudatuda/nix-wallpapers";
      };
      # other flake stuff...
    }
    ```
2. Use the `wallpapers` output in your configuration
    Example with [Stylix](https://github.com/danth/stylix):
    ```nix
    { inputs, ... }: {
        stylix.image = inputs.nix-wallpapers.wallpapers.tiles.calm;
    }
    ```

## How It Works
- `flake.nix`: Defines the Flake and its outputs. It imports `lib.nix` and uses the *processImages* function to transform the `./wallpapers` directory into an **attribute set**.
- `lib.nix`: Contains the logic for recursively processing directories. It:
    - Reads the directory contents with `builtins.readDir`.
    - Filters out *non-regular files* and *README.md*.
    - Strips file extensions to create clean attribute names.
    - Recursively processes subdirectories.
    - Outputs an attribute set where each image is a Nix path.
- `wallpapers/`: The directory containing the wallpaper images. Subdirectories like `tiles/` are preserved in the attribute set structure.

## TODO
- [ ] Add function to replace spaces with `-` in filenames
- [ ] Add function to make all filenames lowercase
