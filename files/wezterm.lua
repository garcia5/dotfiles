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
config.font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Medium" })
config.font_size = font_size

-- mappings
config.leader = { key = " ", mods = "CTRL", timeout_milliseconds = 500 } -- keep my tmux muscle memory
config.keys = {
    {
        key = "r",
        mods = "CMD|SHIFT",
        action = act.ReloadConfiguration,
    },
    {
        key = "l",
        mods = "ALT",
        action = act.ShowLauncherArgs({ flags = "FUZZY|LAUNCH_MENU_ITEMS|WORKSPACES|COMMANDS|TABS" }),
    },
    {
        key = "|",
        mods = "LEADER",
        action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "_",
        mods = "LEADER",
        action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "h",
        mods = "LEADER",
        action = act.ActivatePaneDirection("Left"),
    },
    {
        key = "j",
        mods = "LEADER",
        action = act.ActivatePaneDirection("Down"),
    },
    {
        key = "k",
        mods = "LEADER",
        action = act.ActivatePaneDirection("Up"),
    },
    {
        key = "l",
        mods = "LEADER",
        action = act.ActivatePaneDirection("Right"),
    },
    {
        key = "r",
        mods = "LEADER",
        action = act.ActivateKeyTable({
            name = "resize_pane",
            one_shot = false,
        }),
    },
    {
        key = "z",
        mods = "LEADER",
        action = act.TogglePaneZoomState,
    },
    {
        key = "s",
        mods = "LEADER",
        action = act.ShowLauncherArgs({ flags = "WORKSPACES|FUZZY" }),
    },
    { key = "+", mods = "CMD", action = act.IncreaseFontSize },
    { key = "-", mods = "CMD", action = act.DecreaseFontSize },
    { key = ".", mods = "CMD", action = act.ResetFontSize },
}

config.key_tables = {
    resize_pane = {
        { key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
        { key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
        { key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
        { key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
        -- Cancel the mode by pressing escape
        { key = "Escape", action = "PopKeyTable" },
    },
}

return config
