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

-- Native LSP completion popups. obsidian.nvim runs its own in-process LSP
-- (started by the plugin itself) to drive [[ / # / [^ completion — this
-- generic LspAttach hook is what makes that popup fire automatically
-- instead of requiring manual <C-x><C-o>. Also benefits harper_ls above.
--
-- Buffer-local so these only exist where an LSP client is actually
-- attached (markdown/text/gitcommit, via harper_ls or obsidian's own
-- in-process LSP) — <leader>ca is how you act on a harper-ls suggestion
-- (word choice, style, grammar): it lists that line's fixes and applies
-- the one you pick.
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = true })

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
