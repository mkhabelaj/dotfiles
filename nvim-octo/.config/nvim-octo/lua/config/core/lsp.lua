-- harper-ls: grammar + spell checker for review prose.
-- nvim 0.12 native LSP (no nvim-lspconfig). octo buffers are filetype "octo",
-- not in harper's defaults, so filetypes is overridden explicitly.
-- Guarded on the binary so absent harper-ls never errors.
-- Install: via mise (cargo:harper-ls in mise config.toml), then `mise install`
if vim.fn.executable("harper-ls") == 1 then
	vim.lsp.config("harper_ls", {
		cmd = { "harper-ls", "--stdio" },
		filetypes = { "octo", "markdown", "gitcommit", "text" },
	})
	vim.lsp.enable("harper_ls")
end
