{ pkgs, ... }:
{
  luaLoader.enable = true;
  env.FOO = "bar";
  extraFiles = {
    "queries/python/injections.scm" = {
      text = ''
            ;extends
        ;all_sql

          (string
            (string_content) @injection.content
              (#vim-match? @injection.content "#R")
              (#set! injection.language "r")
        ) @Rbg'';
    };
  };
  lsp = {
    servers.flow.enable = true;
  };
  plugins.lspconfig = {
    enable = true;

    package = pkgs.vimPlugins.nvim-lspconfig.overrideAttrs {
      src = /home/gaetan/temp/nvim-lspconfig;
    };
  };
}
