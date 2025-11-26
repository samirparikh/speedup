# speedup

A simple command-line tool to speed up audio files by 1.8x using ffmpeg.

## Usage
```bash
speedup input.mp3 output
```

The script will automatically add `.mp3` extension if not provided.

## Installation

### With Nix Flakes

Try it without installing:
```bash
nix run github:samirparikh/speedup -- input.mp3 output
```

Install to your profile:
```bash
nix profile install github:samirparikh/speedup
```

### In NixOS Configuration

Add to your `flake.nix`:
```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    speedup.url = "github:samirparikh/speedup";
  };

  outputs = { self, nixpkgs, speedup, ... }: {
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          environment.systemPackages = [
            speedup.packages.${pkgs.system}.speedup
          ];
        })
      ];
    };
  };
}
```

### Using the Overlay
```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    speedup.url = "github:samirparikh/speedup";
  };

  outputs = { self, nixpkgs, speedup, ... }: {
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ speedup.overlays.default ];
          environment.systemPackages = [ pkgs.speedup ];
        })
      ];
    };
  };
}
```

## Requirements

- ffmpeg (automatically included as a dependency)

## License

MIT
