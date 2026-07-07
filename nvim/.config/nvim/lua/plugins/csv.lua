return {
	-- Non-destructive aligned column view for CSV/TSV. The file stays raw text;
	-- columns render aligned and update live as you edit / add / delete / paste
	-- rows. Auto-enabled on csv/tsv buffers below.
	{
		"hat0uma/csvview.nvim",
		ft = { "csv", "tsv" },
		opts = {
			parser = { comments = { "#" } },
			view = { display_mode = "border" },
		},
		config = function(_, opts)
			require("csvview").setup(opts)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "csv", "tsv" },
				callback = function()
					vim.cmd("CsvViewEnable")
				end,
			})
			-- The buffer that lazy-loaded this plugin already fired its FileType
			-- before the autocmd existed, so enable it directly.
			if vim.tbl_contains({ "csv", "tsv" }, vim.bo.filetype) then
				vim.cmd("CsvViewEnable")
			end
		end,
	},

	-- Rainbow-colored columns + RBQL: SQL-like `:Select a1, a3 where a2 > 5`
	-- queries and column navigation over the CSV.
	{
		"cameron-wags/rainbow_csv.nvim",
		config = true,
		ft = { "csv", "tsv", "csv_semicolon", "csv_whitespace", "csv_pipe" },
		cmd = {
			"RainbowDelim",
			"RainbowDelimSimple",
			"RainbowMultiDelim",
			"RainbowNoDelim",
			"RainbowComment",
			"RainbowCellGoUp",
			"RainbowCellGoDown",
			"Select",
			"Update",
		},
	},
}
