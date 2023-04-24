{
  # inputs.nixpkgs.url = "/home/gaetan/perso/nix/nixpkgs";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nixvim = {
    url = "/home/gaetan/perso/nix/nixvim/nixvim";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nixvim,
  }: let
    system = "x86_64-linux";
    # pkgs = import nixpkgs {inherit system;};

    nixvim' = nixvim.legacyPackages.${system};
    nvim =
      nixvim'.makeNixvimWithModule
      {
        # inherit pkgs;
        module = {
          filetype.extension."typ" = "typst";
          plugins = {
            # coq-nvim.enable = true;
            lsp = {
              enable = true;

              servers = {
                typst-lsp.enable = true;
                bashls.enable = true;
              };
            };
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
