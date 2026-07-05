return {
	"brenoprata10/nvim-highlight-colors",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		render = "background", -- or "foreground", "virtual"
		enable_named_colors = true,
		enable_tailwind = true, -- highlights tailwind classes too
	},
}
