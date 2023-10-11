local fn = vim.fn

local M = {}

M.DEFAULT_SETTINGS = {
	colorscheme = "habamax",
	format_on_save = false,
}

M.LAZY_PATH = fn.stdpath("data") .. "/lazy/lazy.nvim"
M.LAZY_CLONE_CMD = {
	"git",
	"clone",
	"--filter=blob:none",
	"https://github.com/folke/lazy.nvim.git",
	"--branch=stable",
	M.LAZY_PATH,
}

M.SETTINGS_FILE_NAME = ".stardog.json"
M.SETTINGS_FILEPATH = fn.getcwd() .. "/" .. M.SETTINGS_FILE_NAME

return M
