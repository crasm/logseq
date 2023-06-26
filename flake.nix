{
  # Enter the nix dev shell using:
  # `$ nix develop -c $SHELL`

  description = "Nix development shell for logseq";

  # Flake inputs
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.05";
  };

  # Flake outputs
  outputs = { self, nixpkgs }:
    let
      allSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs {
          inherit system;
        };
      });
    in
    {
      devShells = forAllSystems ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            babashka # Downloads its own small clojure interpreter and places in ~/.deps.clj
            jdk11
            clojure
            nodejs-18_x # Node.js 18, plus npm, npx, and corepack
            yarn
          ];
        };
      });
    };
}
