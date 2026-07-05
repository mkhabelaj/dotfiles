-- Prose-tuned, not identical to nvim-octo's: harper-ls can raise many
-- grammar/style suggestions per paragraph, so inline virtual_text is too
-- noisy for a writing tool. Show signs + underline only; the full message
-- for the current line renders via virtual_lines (appears while the cursor
-- is on that line). Use vim.diagnostic.open_float() to inspect anything not
-- on the current line.
vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = { current_line = true },
	underline = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = " ",
		},
	},
})
