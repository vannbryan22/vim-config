-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--

-- local Terminal = require("toggleterm.terminal").Terminal
-- local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })
-- --
-- function _lazygit_toggle()
--   lazygit:toggle()
-- end
-- vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })


-- ~/.config/nvim/lua/config/diagnostics.lua
vim.diagnostic.config({
  virtual_text = false,  -- Disable inline text
  signs = true,          -- Show error signs in the gutter
  float = {
    border = "rounded",  -- Rounded borders for floating windows
    source = "always",   -- Show the source of diagnostics
    header = "",         -- No header
    prefix = "",         -- No prefix for the error messages
    format = function(diagnostic)
      -- Format diagnostic message to wrap text for better readability
      return string.format("%s", diagnostic.message)
    end,
  }
})

-- Manually trigger diagnostic floating window with key mapping
vim.api.nvim_set_keymap('n', '<Leader>d', '<cmd>lua vim.diagnostic.open_float(nil, { width = 80 })<CR>', { noremap = true, silent = true })

-- Limit the floating window width and ensure text wrapping
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
  max_width = 80,  -- Set a maximum width for diagnostic messages
  max_height = 12,  -- Set a maximum height to avoid large popups
  wrap = true,    -- Wrap long lines in the hover window
})
