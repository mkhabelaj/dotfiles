return {
	"romus204/tree-sitter-manager.nvim",
	dependencies = {}, -- tree-sitter CLI must be installed system-wide
	config = function()
		require("tree-sitter-manager").setup({
			-- Default Options
			ensure_installed = {
				-- Python / Django
				"python",

				-- JavaScript / React
				"javascript",
				"typescript",
				"tsx", -- React JSX with TypeScript
				"jsx", -- React JSX without TypeScript

				-- Web
				"html",
				"css",
				"json",

				-- Neovim config
				"lua",
				"vim",
				"vimdoc",

				-- Useful extras
				"markdown", -- README files
				"bash", -- shell scripts
				"gitcommit", -- better git commit messages
				"gitignore",
				"regex", -- highlights regex inside Python/JS strings
				"toml", -- pyproject.toml, mise config
				"yaml", -- Django settings, CI configs
			},
			-- border = nil, -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
			-- auto_install = false, -- if enabled, install missing parsers when editing a new file
			-- highlight = true, -- treesitter highlighting is enabled by default
			-- languages = {}, -- override or add new parser sources
		})
	end,
}
