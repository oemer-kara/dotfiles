return {
	"ggandor/leap.nvim",
	config = function()
        require('leap').opts.safe_labels = ''

        -- Simple leap setup - just use 'q' to jump anywhere (both directions)
		vim.keymap.set({'n', 'x', 'o'}, 'q', '<Plug>(leap)', {silent = true, desc = "Leap anywhere"})

        vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
    end,
}
