return {
  {
    "s1n7ax/nvim-window-picker",
    version = "v1.*",
    config = function()
      require("window-picker").setup({
        -- the foreground (text) color of the picker
        fg_color = "#2a273f",
        -- if you have include_current_win == true, then current_win_hl_color will
        -- be highlighted using this background color
        current_win_hl_color = "#ea9a97",
        -- all the windows except the curren window will be highlighted using this
        -- color
        other_win_hl_color = "#ea9a97",
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        window = {
          width = 30,
          mappings = {
            ["h"] = "close_node",
            ["l"] = "open",
            ["v"] = "open_vsplit",
          },
        },
      },
    },
  },
}
