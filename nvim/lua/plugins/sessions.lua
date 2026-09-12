vim.o.sessionoptions = "blank,buffers,curdir,help,tabpages,winsize,winpos,terminal,localoptions"
return {
	"rmagatti/auto-session",

	-----------------------------------
	-- Configuration
	-----------------------------------
	config = function()
		require("auto-session").setup({
			log_level = "info",
			suppress_dirs = { "~/", "~/Projects", "~/Downloads" },
			root_dir = vim.fn.stdpath("data") .. "/sessions/",
			enabled = true,
			auto_save = true,
			auto_restore = true,
			args_allow_single_directory = true,
			args_allow_files_auto_save = false,
		})
	end,
}
