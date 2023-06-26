{
  description = "Nix development shell for logseq";

  # Flake inputs
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.05";
  };

  # Flake outputs
  outputs = { self, nixpkgs }:
    let
      # Systems supported
      allSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];

      # Helper to provide system-specific attributes
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs {
          inherit system;
        };
      });
    in
    {
      # Development environment output
      devShells = forAllSystems ({ pkgs }: {
        default = pkgs.mkShell {
          # The Nix packages provided in the environment
          packages = with pkgs; [
            babashka
            jdk11
            clojure  # Invoking `bb dev:lint` downloads its own clojure into ~/.m2 or something
            nodejs-18_x # Node.js 18, plus npm, npx, and corepack
            yarn
          ];
        };
      });
    };
}
