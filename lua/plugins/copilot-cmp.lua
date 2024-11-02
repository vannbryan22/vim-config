return {
  "zbirenbaum/copilot-cmp",
  dependencies = "copilot.lua",
  opts = {},
  config = function(_, opts)
    local copilot_cmp = require("copilot_cmp")
    copilot_cmp.setup(opts)
    -- Attach copilot_cmp source on InsertEnter to handle lazy-loading
    vim.api.nvim_create_autocmd("InsertEnter", {
      callback = function()
        copilot_cmp._on_insert_enter({})
      end,
    })
  end,
}
