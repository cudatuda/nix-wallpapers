# Nix Wallpapers
Personal wallpaper collection as a Nix Flake!
## Usage
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
2. Use output `nix-wallpapers.wallpapers` in code:  
    Example with [Stylix](https://github.com/danth/stylix):
    ```nix
    { inputs, ... }: {
        stylix.image = "${inputs.nix-wallpapers.wallpapers}/gokmedia-blend.png";
    }
    ```

## TODO
- [ ] Add function to replace spaces with `-` in filenames
- [ ] Add function to make all filenames lowercase
