return {
  "airblade/vim-gitgutter",
  event = "BufReadPre",
  config = function()
    -- Optional customization
    vim.g.gitgutter_in_netrw = 1 -- Enable in Netrw
    vim.g.gitgutter_sign_added = "+"
    vim.g.gitgutter_sign_modified = "~"
    vim.g.gitgutter_sign_removed = "-"
  end,
}
