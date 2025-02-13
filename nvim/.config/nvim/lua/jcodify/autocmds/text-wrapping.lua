vim.api.nvim_create_autocmd({ "VimEnter", "BufReadPost" }, {
	pattern = { "*.md", "*.txt", "*.gitcommit" },
	callback = function()
		vim.wo.wrap = true
		vim.wo.linebreak = true
		vim.wo.breakindent = true
		-- Open Zen Mode with dynamic width
		ToggleZenMode()
	end,
})
