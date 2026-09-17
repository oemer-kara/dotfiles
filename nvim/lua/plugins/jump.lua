return {
	"ggandor/leap.nvim",
	-- Upstream gutted the GitHub repo ("nuke it from orbit") and moved
	-- development to Codeberg; the GitHub mirror no longer has source.
	url = "https://codeberg.org/andyg/leap.nvim.git",
	config = function()
        require('leap').opts.safe_labels = ''

        -- Simple leap setup - just use 'q' to jump anywhere (both directions)
		vim.keymap.set({'n', 'x', 'o'}, 'q', '<Plug>(leap)', {silent = true, desc = "Leap anywhere"})

        vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
    end,
}
