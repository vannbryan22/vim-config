return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "folke/neodev.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    { "j-hui/fidget.nvim", opts = {} }, -- Optional, for showing LSP progress
    { "https://git.sr.ht/~whynothugo/lsp_lines.nvim" }, -- Diagnostic lines
    "b0o/SchemaStore.nvim", -- Schema support for JSON/YAML
  },
  config = function()
    -- Neodev setup
    require("neodev").setup()

    -- Check if cmp_nvim_lsp is available and set capabilities
    local capabilities = nil
    if pcall(require, "cmp_nvim_lsp") then
      capabilities = require("cmp_nvim_lsp").default_capabilities()
    end

    -- Set up LSP servers
    local lspconfig = require("lspconfig")

    local servers = {
      bashls = true,
      gopls = {
        settings = {
          gopls = {
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
      },
      templ = {},
      html = {
        filetypes = { "html", "templ" },
      },
      htmx = {
        filetypes = { "html", "templ" },
      },
      lua_ls = {
        server_capabilities = {
          semanticTokensProvider = vim.NIL,
        },
      },
      rust_analyzer = true,
      cssls = true,
      taplo = true,
      pyright = true,
      ts_ls = {
        server_capabilities = {
          documentFormattingProvider = false,
        },
      },
      jsonls = {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      },
      yamlls = {
        settings = {
          yaml = {
            schemaStore = {
              enable = false,
              url = "",
            },
          },
        },
      },
    }

    -- Install and configure Mason
    require("mason").setup()
    local ensure_installed = {
      "stylua",
      "lua_ls",
      "delve",
    }
    vim.list_extend(ensure_installed, vim.tbl_keys(servers))
    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

    -- Setup LSP servers
    for name, config in pairs(servers) do
      if config == true then
        config = {}
      end
      config = vim.tbl_deep_extend("force", { capabilities = capabilities }, config)
      lspconfig[name].setup(config)
    end

    -- Handle LSP Attach events
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local filetype = vim.bo[bufnr].filetype

        -- Set key mappings for LSP functions
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = bufnr })
        vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = bufnr })
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
        vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = bufnr })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
        vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { buffer = bufnr })
        vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = bufnr })

        -- Disable semantic tokens if specified
        if filetype == "lua" then
          client.server_capabilities.semanticTokensProvider = nil
        end

        -- Safely override client capabilities if servers[client.name] exists
        if servers[client.name] and servers[client.name].server_capabilities then
          for key, value in pairs(servers[client.name].server_capabilities) do
            client.server_capabilities[key] = value
          end
        end
      end,
    })

    -- Setup diagnostic lines
    require("lsp_lines").setup()
    vim.diagnostic.config({ virtual_text = false })
  end,
}
