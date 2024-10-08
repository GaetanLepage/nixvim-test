{
  inputs = {
    # nixpkgs.url = "/home/gaetan/perso/nix/nixpkgs";
    # nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixvim = {
      url = "/home/gaetan/perso/nix/nixvim/nixvim";
      # url = "github:nix-community/nixvim";
      # url = "github:nix-community/nixvim/nixos-23.05";
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
          formatter = pkgs.alejandra;
          packages = {
            # inherit lsp-format-nvim;
            default = inputs'.nixvim.legacyPackages.makeNixvimWithModule {
              inherit pkgs;
              module =
                { pkgs, ... }:
                {
                  plugins = {
                    avante = {
                      enable = true;
                      settings = {
                        openai = {
                          endpoint = "https://api.openai.com/v1";
                          model = "gpt-4o";
                          timeout = 30000;
                          temperature = 0;
                          max_tokens = 4096;
                          "__rawKey__'local'" = false;
                        };
                      };
                    };
                  };
                };
            };
          };
        };
    };
}
