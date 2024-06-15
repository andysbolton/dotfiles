return {
  name = "nix",
  ft = { "nix" },
  ls = {
    name = "nil_ls",
    settings = {},
  },
  formatter = {
    name = "nixpkgs-fmt",
    actions = {
      function() return require("formatter.filetypes.nix").nixpkgs_fmt() end,
    },
  },
  treesitter = "nix",
}
