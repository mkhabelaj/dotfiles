-- Create an augroup to prevent duplicates
vim.api.nvim_create_augroup("WrapSettings", { clear = true })

-- Enable wrap for markdown, text, and gitcommit file types
vim.api.nvim_create_autocmd("FileType", {
	group = "WrapSettings",
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.wo.wrap = true
		vim.wo.linebreak = true
		vim.wo.breakindent = true
		print("✅ Word Wrap: ON for " .. vim.bo.filetype)
	end,
})
