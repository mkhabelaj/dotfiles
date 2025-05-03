local function venv_name()
	local venv = require("venv-selector").venv()
	if venv and venv ~= "" then
		-- :t gives you only the last component of the path
		return "🐍 " .. vim.fn.fnamemodify(venv, ":t")
	end
	return ""
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		-- configure lualine with modified theme
		lualine.setup({
			options = {
				theme = "catppuccin",
				component_separators = "",
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
					},
					venv_name,
					{ "encoding" },
					{ "fileformat" },
					{ "filetype" },
				},
			},
		})
	end,
}
