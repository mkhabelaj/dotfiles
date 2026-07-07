-- harper-ls: grammar + spell checker for prose.
-- nvim 0.12 native LSP (no nvim-lspconfig). Guarded on the binary so absent
-- harper-ls never errors.
-- Install: via mise (cargo:harper-ls in mise config.toml), then `mise install`
if vim.fn.executable("harper-ls") == 1 then
	vim.lsp.config("harper_ls", {
		cmd = { "harper-ls", "--stdio" },
		filetypes = { "markdown", "gitcommit", "text" },
	})
	vim.lsp.enable("harper_ls")
end

-- LSP-attached keymaps. Completion itself is driven by blink.cmp (see
-- plugins.lua), which sources obsidian's in-process LSP ([[ / # / [^) and
-- harper-ls through its `lsp` source — so no vim.lsp.completion.enable here
-- (that would double-fire alongside blink's popup).
--
-- Buffer-local so these only exist where an LSP client is actually
-- attached (markdown/text/gitcommit, via harper_ls or obsidian's own
-- in-process LSP) — <leader>ca is how you act on a harper-ls suggestion
-- (word choice, style, grammar): it lists that line's fixes and applies
-- the one you pick.
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local opts = { buffer = args.buf }
		vim.keymap.set(
			"n",
			"<leader>ca",
			vim.lsp.buf.code_action,
			vim.tbl_extend("force", opts, { desc = "Code action (apply harper-ls suggestion)" })
		)
		vim.keymap.set(
			"n",
			"<leader>cd",
			vim.diagnostic.open_float,
			vim.tbl_extend("force", opts, { desc = "Show diagnostic (harper-ls suggestion detail)" })
		)
	end,
})
