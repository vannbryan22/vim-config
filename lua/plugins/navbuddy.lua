return {
  "SmiteshP/nvim-navbuddy",
  dependencies = {
    "neovim/nvim-lspconfig",
    "SmiteshP/nvim-navic",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>nb", "<cmd>Navbuddy<cr>", desc = "Open Navbuddy" },
  },
  config = function()
    require("nvim-navbuddy").setup({
      window = {
        border = "rounded",
        size = "80%",
        sections = {
          left = {
            size = "10%",
            border = nil, -- You can set border style for each section individually as well.
          },
          mid = {
            size = "40%",
            border = nil,
          },
          right = {
            -- No size option for right most section. It fills to
            -- remaining area.
            border = nil,
            preview = "leaf", -- Right section can show previews too.
            -- Options: "leaf", "always" or "never"
          },
        },
      },
      lsp = {
        auto_attach = true, -- Automatically attach to LSP on buffer enter
      },
    })
  end,
}
