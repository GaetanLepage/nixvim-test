{
  inputs = {
    # nixpkgs.url = "/home/gaetan/perso/nix/nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixvim = {
      # url = "/home/gaetan/perso/nix/nixvim/nixvim";
      url = "github:pta2002/nixvim";
      # url = "github:pta2002/nixvim/nixos-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixvim,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    # pkgs-unstable = import nixpkgs {
    #   inherit system;
    #   config.allowUnfree = true;
    # };

    nixvim' = nixvim.legacyPackages.${system};
    nvim =
      nixvim'.makeNixvimWithModule
      {
        # inherit pkgs;
        module = {
          plugins = {
            lualine.enable = true;
            # lsp = {
            #   enable = true;
            #   servers = {
            #     nil_ls.enable = true;
            #   };
            # };
          };
        };
      };
  in {
    packages.${system}.default = nvim;
    apps.${system}.default = {
      type = "app";
      program = "${nvim}/bin/nvim";
    };
    # formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
