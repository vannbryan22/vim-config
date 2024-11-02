return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip",
    {
      "zbirenbaum/copilot-cmp",
      dependencies = "copilot.lua",
      opts = {},
      config = function(_, opts)
        local copilot_cmp = require("copilot_cmp")
        copilot_cmp.setup(opts)
        -- attach cmp source whenever copilot attaches
        vim.api.nvim_create_autocmd("InsertEnter", {
          callback = function()
            copilot_cmp._on_insert_enter({})
          end,
        })
      end,
    },
  },
  opts = function(_, opts)
    -- Initialize opts and opts.sources if not already defined
    opts = opts or {}
    opts.sources = opts.sources or {}
    table.insert(opts.sources, 1, {
      name = "copilot",
      group_index = 1,
      priority = 100,
    })
  end,
  config = function()
    local cmp = require("cmp")
    vim.opt.completeopt = { "menu", "menuone", "noselect" }

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      window = {
         completion = cmp.config.window.bordered(),
         documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "luasnip" }, -- For luasnip users.
        -- { name = "orgmode" },
      }, {
        { name = "buffer" },
        { name = "path" },
      }),
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })
  end,
}
