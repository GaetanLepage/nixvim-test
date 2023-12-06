{
  inputs = {
    nixpkgs.url = "/home/gaetan/perso/nix/nixpkgs";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixvim = {
      url = "/home/gaetan/perso/nix/nixvim/nixvim";
      # url = "github:nix-community/nixvim";
      # url = "github:nix-community/nixvim/nixos-23.05";
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

    nixvim' = nixvim.legacyPackages.${system};
    nvim =
      nixvim'.makeNixvimWithModule
      {
        # inherit pkgs;
        module = {helpers, ...}: {
          colorschemes.gruvbox.enable = true;
          plugins = {
            indent-blankline.enable = true;
          };
          keymaps = [
            {
              mode = "n";
              key = "<C-a>";
              action = "function() print('hello') end";
              lua = true;
            }
          ];
        };
      };
  in {
    packages.${system}.default = nvim;
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
