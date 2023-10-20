local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

if wezterm.config_builder then config = wezterm.config_builder() end
config.automatically_reload_config = true

-- startup
config.default_prog = { "/bin/zsh", "-l" }

-- colors
config.color_scheme = "Catppuccin Mocha"

-- look & feel
local font_size = 14.0
config.adjust_window_size_when_changing_font_size = false
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
        key = "P",
        mods = "CMD",
        action = wezterm.action.ActivateCommandPalette,
    },
    {
        key = "|",
        mods = "LEADER",
        action = wezterm.action_callback(function(_, pane)
            local dimensions = pane:get_dimensions()
            local size = 0.5
            if dimensions.cols >= 300 then size = 0.33 end
            pane:split(({ direction = "Right", size = size }))
        end),
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
    {
        key = " ",
        mods = "LEADER",
        action = act.RotatePanes("Clockwise"),
    },
    {
        key = "f",
        mods = "LEADER",
        action = act.PaneSelect,
    },
    {
        key = "x",
        mods = "LEADER",
        action = act.PaneSelect({ mode = "SwapWithActive" }),
    },
    { key = "+", mods = "CMD", action = act.IncreaseFontSize },
    { key = "-", mods = "CMD", action = act.DecreaseFontSize },
    { key = ".", mods = "CMD", action = act.ResetFontSize },
    { key = "u", mods = "LEADER", action = act.QuickSelect },
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

-- better hyperlink detection
local link_rules = wezterm.default_hyperlink_rules()
link_rules[5] = nil -- remove default email rule
table.insert(link_rules, {
    regex = [[\b([A-Z]{2,9}?-\d+?)\b]],
    format = "https://dotdash.atlassian.net/browse/$1",
})
config.hyperlink_rules = link_rules

return config
