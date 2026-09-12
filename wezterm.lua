local wezterm = require 'wezterm'
local config = wezterm.config_builder and wezterm.config_builder() or {}

-- Shell: PowerShell 7 via the Scoop shim
config.default_prog = { 'C:\\ws\\scoop\\shims\\pwsh.exe', '-NoLogo' }
config.default_cwd = 'C:\\ws'

-- Font (installed via Scoop as "JetBrainsMono NF", not "JetBrainsMono Nerd Font")
config.font = wezterm.font 'JetBrainsMono NF'
config.font_size = 12.0
config.line_height = 1.1

config.front_end = 'WebGpu'
config.color_scheme = 'Afterglow'
config.window_background_opacity = 1.0
config.window_padding = { left = 14, right = 14, top = 10, bottom = 10 }
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.default_cursor_style = 'SteadyBar'
config.window_frame = {
  font = wezterm.font { family = 'JetBrainsMono NF', weight = 'Bold' },
  font_size = 11.0,
}

-- Tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false

-- Pane splitting keybinds (Leader = Ctrl+A, tmux-style)
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  { key = '|', mods = 'LEADER|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'h', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'x', mods = 'LEADER', action = wezterm.action.CloseCurrentPane { confirm = true } },
}

return config
