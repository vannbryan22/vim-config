return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  config = function()
    require("copilot").setup({
      suggestion = {
        auto_trigger = true,
      },
      panel = {
        enabled = true,
      },
      auto_trigger = true,
      filetypes = {
        markdown = true,
        help = true,
      },
      server_opts_overrides = {
        trace = "verbose",
        settings = {
          advanced = {
            listCount = 10, -- #completions for panel
            inlineSuggestCount = 3, -- #completions for getCompletions
          },
        },
      },
    })
  end,
}
