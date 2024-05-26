{
  inputs = {
    # nixpkgs.url = "/home/gaetan/perso/nix/nixpkgs";
    # nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixvim = {
      # url = "/home/gaetan/perso/nix/nixvim/nixvim";
      url = "github:nix-community/nixvim";
      # url = "github:nix-community/nixvim/nixos-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixvim,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem = {
        pkgs,
        inputs',
        ...
      }: {
        formatter = pkgs.alejandra;
        packages = let
          # lsp-format-nvim = pkgs.vimUtils.buildVimPlugin {
          #   name = "lsp-format-nvim";
          #   src = /home/gaetan/temp/lsp-format.nvim;
          #   # src = pkgs.fetchFromGitHub {
          #   #   owner = "lukas-reineke";
          #   #   repo = "lsp-format.nvim";
          #   #   rev = "3612642b0e2eb85015838df5dcfbacb61f15db98";
          #   #   sha256 = "1pizkn16ma7yfsy19g06f6l6zkqwsjkmzybqhhhp18xbbyj7m8cc";
          #   # };
          # };
        in {
          # inherit lsp-format-nvim;
          default = inputs'.nixvim.legacyPackages.makeNixvimWithModule {
            inherit pkgs;
            module = {pkgs, ...}: {
              plugins = {
                lsp-format = {
                  enable = true;
                  # package = lsp-format-nvim;
                  lspServersToEnable = ["tinymist"];
                  setup.typst.force_attach = true;
                };
                lsp = {
                  enable = true;
                  servers.tinymist = {
                    enable = true;
                    settings.formatterMode = "typstyle";
                  };
                };
              };
            };
          };
        };
      };
    };
}
