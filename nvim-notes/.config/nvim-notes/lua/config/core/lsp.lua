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
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = true })
	end,
})
