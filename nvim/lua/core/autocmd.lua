local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Create a dedicated group for better organization
local user_group = augroup("UserAutoCmds", { clear = true })

-- Restore cursor position when reopening files
autocmd("BufReadPost", {
    group = user_group,
    pattern = "*",
    callback = function()
        local last_pos = vim.fn.line("'\"")
        if last_pos > 1 and last_pos <= vim.fn.line("$") then
            vim.cmd("normal! g`\"")
        end
    end,
})

-- Briefly highlight yanked text for visual feedback
autocmd("TextYankPost", {
    group = user_group,
    pattern = "*",
    callback = function()
        vim.hl.on_yank { higroup = "IncSearch", timeout = 200 }
    end,
})

-- Automatically resize splits when Neovim window is resized
autocmd("VimResized", {
    group = user_group,
    pattern = "*",
    command = "wincmd =",
})

-- Automatically remove trailing whitespace when saving files
autocmd("BufWritePre", {
    group = user_group,
    pattern = "*",
    callback = function()
        local view = vim.fn.winsaveview()
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.winrestview(view)
    end,
})

-- Cursorline: show only in active window and normal mode
autocmd({ "WinEnter", "BufEnter", "InsertLeave" }, {
    group = user_group,
    pattern = "*",
    command = "setlocal cursorline",
})

autocmd({ "WinLeave", "InsertEnter" }, {
    group = user_group,
    pattern = "*",
    command = "setlocal nocursorline",
})

-- Disable auto commenting on newline
autocmd("BufEnter", {
    group = user_group,
    pattern = "*",
    command = "setlocal formatoptions-=cro",
})

-- Auto reload the file if changed outside of nvim
autocmd({ "FocusGained", "BufEnter" }, {
    group = user_group,
    pattern = "*",
    command = "checktime",
})
