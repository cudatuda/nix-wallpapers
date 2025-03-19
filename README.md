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

## Structure
The flake organizes wallpapers based on the directory structure. **The attribute structure exactly mirrors the directory structure of the images**, with file extensions removed from attribute names:
```
# Directory structure
wallpapers/                           
├── image-1.png                
└── collection-1/
    ├── image-2.png
    └── ...

# Corresponding attribute structure
wallpapers                           
├── image-1                    
└── collection-1
    ├── image-2
    └── ...
```
This one-to-one mapping makes it intuitive to access any wallpaper based on its location in the directory structure.

## TODO
- [ ] Add function to replace spaces with `-` in filenames
- [ ] Add function to make all filenames lowercase
