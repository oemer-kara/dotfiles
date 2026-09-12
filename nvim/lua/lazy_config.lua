-- Set the path where Lazy.nvim will be installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check if Lazy.nvim is already installed at the specified path
if not vim.uv.fs_stat(lazypath) then
    -- If not installed, clone the repository from GitHub
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none", -- Use partial clone to save bandwidth
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- Clone the stable branch
        lazypath,
    })
    
    -- Print a message to confirm installation
    print("Installed Lazy.nvim. Restart may be required for first-time setup.")
end

-- Add Lazy.nvim to the runtime path
vim.opt.rtp:prepend(lazypath)

-- Handle potential errors during initialization
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
    vim.notify("Failed to load Lazy.nvim: " .. lazy, vim.log.levels.ERROR)
    return
end

-- Initialize Lazy.nvim with configuration
lazy.setup({
    -- Import all plugins specified in the "plugins" directory
    -- Expects modules like "plugins/lsp.lua", "plugins/ui.lua", etc.
    { import = "plugins" },
}, {
    -- Plugin update checking configuration
    checker = {
        enabled = true, -- Enable automatic checking for plugin updates
        notify = false, -- Disable notifications about updates
        frequency = 86400, -- Check once a day (in seconds)
    },
    -- Change detection configuration
    change_detection = {
        enabled = true, -- Enable change detection
        notify = false, -- Disable notifications about config changes
    },
    -- No plugin here requires luarocks (checkhealth confirms this), but lazy
    -- still probes for a hererocks install and reports its absence as an ERROR.
    -- Turning it off removes that false positive from :checkhealth.
    rocks = { enabled = false },
    -- Performance settings
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
    -- Provides a clear way to check Lazy.nvim status
    ui = {
        border = "rounded",
    },
})

-- Create a command to easily open Lazy.nvim management UI
vim.api.nvim_create_user_command("LazyStatus", function()
    require("lazy").home()
end, { desc = "Open Lazy.nvim management UI" })
