return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = { spelling = true },
    defaults = {
      mode = { "n", "v" },
      ["<leader>b"] = { name = "+buffer" },
      ["<leader>f"] = { name = "+file/find" },
      ["<leader><tab>"] = { name = "+tab" },
      ["<leader>w"] = { name = "+window" },
      ["<leader>q"] = { name = "+quit" },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.register(opts.defaults)
  end,
}
