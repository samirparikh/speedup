{
  description = "A simple script to speed up audio files by 1.8x using ffmpeg";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Read the script from the external file
        scriptContent = builtins.readFile ./speedup.sh;
        
        # Create the package
        speedup = pkgs.stdenv.mkDerivation {
          pname = "speedup";
          version = "1.0.0";
          
          src = ./.;
          
          buildInputs = [ pkgs.makeWrapper ];
          
          installPhase = ''
            mkdir -p $out/bin
            cp ${./speedup.sh} $out/bin/speedup
            chmod +x $out/bin/speedup
            
            # Wrap the script to ensure ffmpeg is in PATH
            wrapProgram $out/bin/speedup \
              --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.ffmpeg ]}
          '';
          
          meta = with pkgs.lib; {
            description = "Speed up audio files by 1.8x using ffmpeg";
            license = licenses.mit;
            platforms = platforms.linux ++ platforms.darwin;
          };
        };
      in
      {
        packages = {
          speedup = speedup;
          default = speedup;
        };

        apps = {
          speedup = {
            type = "app";
            program = "${speedup}/bin/speedup";
          };
          default = self.apps.${system}.speedup;
        };
      }
    ) // {
      # Overlay for use in NixOS configurations
      overlays.default = final: prev: {
        speedup = self.packages.${final.system}.speedup;
      };
    };
}
