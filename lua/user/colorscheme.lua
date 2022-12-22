require("tokyonight").setup({
    transparent = false,
    styles = {
        --m  sidebars = "transparent",
        -- floats = "transparent",
    },
    on_colors = function(colors)
        -- fg_gutter is way to dark to be LineNr
        colors.fg_gutter = colors.fg_sidebar
    end
})

local colorscheme = "tokyonight"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
    vim.notify("Failed to set colorscheme " .. colorscheme)
    return
end

