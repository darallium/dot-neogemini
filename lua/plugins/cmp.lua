---@class CmpSnippetConfig
---@field expand fun(args: { body: string })

---@class CmpWindowConfig
---@field completion table
---@field documentation table

---@class CmpMappingConfig
---@field ['<C-b>'] fun()
---@field ['<C-f>'] fun()
---@field ['<C-Space>'] fun()
---@field ['<C-e>'] fun()
---@field ['<CR>'] fun()
---@field ['<Tab>'] fun(fallback: fun())
---@field ['<S-Tab>'] fun(fallback: fun())

---@class CmpSourceConfig
---@field name string

---@class CmpFormatEntry
---@field entry table
---@field vim_item table

---@class CmpFormattingConfig
---@field format fun(entry: CmpFormatEntry, vim_item: table): table

---@class CmpExperimentalConfig
---@field ghost_text boolean

---@class CmpConfig
---@field snippet CmpSnippetConfig
---@field window CmpWindowConfig
---@field mapping CmpMappingConfig
---@field sources CmpSourceConfig[]
---@field formatting CmpFormattingConfig
---@field experimental CmpExperimentalConfig

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "onsails/lspkind.nvim",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    require("luasnip.loaders.from_vscode").lazy_load()

    ---@type CmpConfig
    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
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
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }),
      formatting = {
        format = require("lspkind").cmp_format({
          mode = "symbol_text",
          maxwidth = 50,
          ellipsis_char = "...",
          show_labelDetails = true,
          before = function(entry, vim_item)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
              cmdline = "[Cmd]",
            })[entry.source.name]
            return vim_item
          end,
        }),
      },
      experimental = {
        ghost_text = true,
      },
    })

    cmp.setup.cmdline(":", {
      sources = cmp.config.sources({
        { name = "cmdline" },
        { name = "path" },
      }),
    })

    cmp.setup.cmdline("/", {
      sources = cmp.config.sources({
        { name = "buffer" },
      }),
    })
  end,
}