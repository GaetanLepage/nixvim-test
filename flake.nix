{
  inputs = {
    # nixpkgs.url = "/home/gaetan/perso/nix/nixpkgs";
    # nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixvim = {
      url = "/home/gaetan/perso/nix/nixvim/nixvim";
      # url = "github:nix-community/nixvim";
      # url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
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
            # inherit lsp-format-nvim;
            default = inputs'.nixvim.legacyPackages.makeNixvimWithModule {
              inherit pkgs;
              module =
                { pkgs, ... }:
                {
                  luaLoader.enable = true;
                  plugins = {
                    oil.enable = true;
                  };
                };
            };
          };
        };
    };
}
