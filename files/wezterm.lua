local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

if wezterm.config_builder then config = wezterm.config_builder() end

-- startup
config.default_prog = { "/bin/zsh", "-l" }

-- colors
config.color_scheme = "tokyonight_night"

-- look & feel
local font_size = 14.0
config.window_frame = {
    font = wezterm.font({ family = "JetBrainsMono Nerd Font Mono" }),
    font_size = font_size,
}
config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
config.font_size = font_size

-- mappings
config.leader = { key = " ", mods = "CTRL", timeout_milliseconds = 500 } -- keep my tmux muscle memory
config.keys = {
    {
        key = "r",
        mods = "CMD|SHIFT",
        action = wezterm.action.ReloadConfiguration,
    },
    {
        key = "l",
        mods = "ALT",
        action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|LAUNCH_MENU_ITEMS|WORKSPACES|COMMANDS|TABS" }),
    },
    {
        key = "|",
        mods = "LEADER",
        action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "_",
        mods = "LEADER",
        action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "h",
        mods = "LEADER",
        action = wezterm.action.ActivatePaneDirection("Left"),
    },
    {
        key = "j",
        mods = "LEADER",
        action = wezterm.action.ActivatePaneDirection("Down"),
    },
    {
        key = "k",
        mods = "LEADER",
        action = wezterm.action.ActivatePaneDirection("Up"),
    },
    {
        key = "l",
        mods = "LEADER",
        action = wezterm.action.ActivatePaneDirection("Right"),
    },
    { key = "+", mods = "CMD", action = act.IncreaseFontSize },
    { key = "-", mods = "CMD", action = act.DecreaseFontSize },
    { key = ".", mods = "CMD", action = act.ResetFontSize },
}

return config
