local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
    vim.notify("Failed to require nvim-lsp-installer")
end

-- Register handler that will be called for all installed servers

