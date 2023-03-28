{
  inputs.nixpkgs.url = "/home/gaetan/perso/nix/nixpkgs";
  inputs.nixvim = {
    url = "/home/gaetan/perso/nix/nixvim";
    inputs.nixpkgs.follows = "nixpkgs";
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
        inherit pkgs;
        module = {
          plugins.coq-nvim.enable = true;
        };
      };
  in {
    packages.${system}.default = nvim;
    apps.${system}.default = {
      type = "app";
      program = "${nvim}/bin/nvim";
    };
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
