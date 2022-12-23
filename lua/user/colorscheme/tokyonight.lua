local status_ok, tokyonight = pcall(require, "tokyonight")
if not status_ok then
	return
end

tokyonight.setup({
	transparent = false,
	styles = {
		-- sidebars = "transparent",
		-- floats = "transparent",
	},
	on_colors = function(colors)
		-- fg_gutter is way to dark to be LineNr
		colors.fg_gutter = colors.fg_sidebar
	end,
})
