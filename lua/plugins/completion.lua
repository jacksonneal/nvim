-- Module for text completion.

local nvim_cmp_opts = function()
  local cmp = require("cmp")
  local luasnip = require("luasnip")

  -- determine if character before cursor is not a space
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0
      and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  return {
    -- provide a snippet engine
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    -- completion sources
    sources = cmp.config.sources({
      -- appear in options in reverse order
      { name = "emoji" },
      { name = "path" },
      { name = "buffer" },
      { name = "luasnip" },
      { name = "nvim_lua" },
      { name = "nvim_lsp" },
    }),
    -- custom mappings
    mapping = {
      -- cycle through options
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          -- menu is visible, go to next option
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          -- can either expand or jump in snippet
          luasnip.expand_or_jump()
        elseif has_words_before() then
          -- non-space characters before cursor, try to complete word
          cmp.complete()
        else
          fallback()
        end
      end),
      -- cycle in reverse
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          -- menu is visible, go to previous option
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          -- can jump backwards in snippet
          luasnip.jump(-1)
        else
          fallback()
        end
      end),
      -- select option
      ["<CR>"] = cmp.mapping(function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
          -- menu is visible with active option
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace })
        else
          fallback()
        end
      end),
    },
    -- experimental options
    experimental = {
      -- completion ghost text appears like comments
      ghost_text = {
        hl_group = "Comment",
      },
    },
  }
end

local plugins = {
  {
    -- completion engine
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- configs for neovim LSP client
      "nvim-lspconfig",
      -- completion source for neovim LSP client
      "hrsh7th/cmp-nvim-lsp",
      -- completion source for neovim Lua API
      "hrsh7th/cmp-nvim-lua",
      -- snippet engine
      "L3MON4D3/LuaSnip",
      -- completion source for LuaSnip
      "saadparwaiz1/cmp_luasnip",
      -- completion source for buffer words
      "hrsh7th/cmp-buffer",
      -- completion source for filesystem paths
      "hrsh7th/cmp-path",
      -- completion source for emojis
      "hrsh7th/cmp-emoji",
    },
    opts = nvim_cmp_opts,
  },
}

return plugins
