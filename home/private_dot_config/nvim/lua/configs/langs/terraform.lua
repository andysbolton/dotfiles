return {
  name = "terraform",
  ft = { "terraform", "tf", "terraform-vars" },
  ls = {
    name = "terraformls",
    settings = {},
  },
  formatter = {
    name = "terraformls",
    use_lsp = true,
  },
  treesitter = "terraform",
}
