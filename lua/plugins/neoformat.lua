return {
  "sbdchd/neoformat",
  keys = {
    {
      "<leader>f",
      function()
        ---@diagnostic disable-next-line: deprecated
        local clients = vim.lsp.buf_get_clients()
        if next(clients) then
          if vim.bo.filetype == "templ" then
            local bufnr = vim.api.nvim_get_current_buf()
            local filename = vim.api.nvim_buf_get_name(bufnr)
            local cmd = "templ fmt " .. vim.fn.shellescape(filename)

            vim.fn.jobstart(cmd, {
              on_exit = function()
                -- Reload the buffer only if it's still the current buffer
                if vim.api.nvim_get_current_buf() == bufnr then
                  vim.cmd("e!")
                end
              end,
            })
          else
            vim.cmd("Neoformat") -- Fallback to Neoformat if no LSP clients are active
          end
        end
      end,
      desc = "Format using LSP or Neoformat",
    },
  },
}
