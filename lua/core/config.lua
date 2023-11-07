-- Module for config settings.

local settings_file_name = ".stardog.json"
local settings_filepath = vim.fn.getcwd() .. "/" .. settings_file_name

local config = {
  initialized = false,
  settings = {
    colorscheme = "habamax",
  },
}

function config.setup()
  if config.initialized then
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
  config.initialized = true
end

return config
