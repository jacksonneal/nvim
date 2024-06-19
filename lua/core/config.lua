-- Module for config settings.

local settings_file_name = ".stardog.json"
local settings_filepath = vim.fn.getcwd() .. "/" .. settings_file_name

local initialized = false
local config = {
  settings = {
    colorscheme = "rose-pine-dawn",
    tailwindcss = {
      disable = false,
    },
    tsserver = {
      disable = false,
    },
    volar = {
      disable = true,
    },
  },
}

function config.setup()
  if initialized then
    return
  end

  if vim.fn.filereadable(settings_filepath) == 0 then
    return
  end

  config.settings = vim.tbl_deep_extend(
    "force",
    config.settings,
    vim.fn.json_decode(vim.fn.readfile(settings_filepath))
  )

  initialized = true
end

return config
