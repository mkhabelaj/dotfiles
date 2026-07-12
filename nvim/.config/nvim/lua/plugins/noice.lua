-- lazy.nvim
return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("noice").setup({
			cmdline = {
				enabled = true,
				view = "cmdline_popup", -- this is what makes it float
			},
			routes = {
				filter = { event = "notify", find = "No information available" },
				opts = { skip = true },
			},
			notify = { enabled = false },
			presets = { lsp_doc_border = true },

			lsp = {
				progress = { enabled = false },
				override = {
					-- override the default lsp markdown formatter with Noice
					["vim.lsp.util.convert_input_to_markdown_lines"] = false,
					-- override the lsp markdown formatter with Noice
					["vim.lsp.util.stylize_markdown"] = false,
					-- override cmp documentation with Noice (needs the other options to work)
					["cmp.entry.get_documentation"] = false,
				},
			},
		})
	end,
}
