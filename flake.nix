{
  inputs = {
    # nixpkgs.url = "/home/gaetan/perso/nix/nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/master";
    # nixpkgs.url = "github:GaetanLepage/nixpkgs/neovim";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixvim = {
      # url = "/home/gaetan/nix/nixvim";
      url = "github:nix-community/nixvim";
      # url = "github:GaetanLepage/nixvim/plugins-lsp";
      # url = "github:nix-community/nixvim/nixos-25.11";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixvim,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem =
        {
          pkgs,
          lib,
          system,
          ...
        }:
        {
          packages.default = inputs.nixvim.lib.nixvim.modules.buildNixvim {
            nixpkgs.hostPlatform = system;
            imports = [ ./config.nix ];
          };
        };
    };
}
