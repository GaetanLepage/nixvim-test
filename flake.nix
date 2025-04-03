{
  inputs = {
    # nixpkgs.url = "/home/gaetan/perso/nix/nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "github:GaetanLepage/nixpkgs/neovim";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixvim = {
      url = "/home/gaetan/nix/nixvim/nixvim";
      # url = "github:nix-community/nixvim";
      # url = "github:nix-community/nixvim/nixos-24.11";
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
          inputs',
          ...
        }:
        {
          packages = {
            default = inputs'.nixvim.legacyPackages.makeNixvimWithModule {
              # inherit pkgs;
              module =
                { pkgs, ... }:
                {
                  luaLoader.enable = true;
                  # spellfiles.enable = true;
                  colorschemes.nord.enable = true;
                  plugins = {
                    image.enable = true;
                  };
                };
            };
          };
        };
    };
}
