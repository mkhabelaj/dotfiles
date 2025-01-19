return {
	"mfussenegger/nvim-dap",
	keys = {
		{
			"<leader>db",
			"<cmd> DapToggleBreakpoint <CR>",
			desc = "Toggle Breakpoint at line",
		},
		{
			"<leader>dus",
			function()
				local widgets = require("dap.ui.widgets")
				local sidebar = widgets.sidebar(widgets.scopes)
				sidebar.open()
			end,
			desc = "Open debubber side panel",
		},
	},
}
