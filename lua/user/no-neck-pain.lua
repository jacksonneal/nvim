local status_ok, no_neck_pain = pcall(require, "no-neck-pain")
if not status_ok then
	return
end

no_neck_pain.setup({
	width = 135,
})
