local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

if wezterm.config_builder then config = wezterm.config_builder() end
config.automatically_reload_config = true

-- startup
config.default_prog = { "/bin/zsh", "-l" }
config.audible_bell = "Disabled" -- NO BELLS
config.window_close_confirmation = "NeverPrompt" -- Shutdown w/o requiring confirmation

-- colors
function get_appearance()
    local appearance = "Dark"
    if wezterm.gui then appearance = wezterm.gui.get_appearance() end
    return appearance
end

function scheme_for_appearance(appearance)
    if appearance:find("Dark") then
        return "Catppuccin Mocha"
    else
        return "Catppuccin Latte"
    end
end
config.color_scheme = scheme_for_appearance(get_appearance())
config.set_environment_variables = {
    THEME_MODE = get_appearance(),
}

-- look & feel
local font_size = 14.0
config.adjust_window_size_when_changing_font_size = false
config.window_frame = {
    font = wezterm.font({ family = "JetBrainsMono Nerd Font Mono" }),
    font_size = font_size,
}
config.window_decorations = "RESIZE"
config.font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Medium" })
config.font_size = font_size
config.max_fps = 100
config.window_padding = {
    left = 5,
    right = 5,
    top = 10,
    bottom = 0,
}

wezterm.on("window-resized", function(window, pane)
    local tab = pane:tab()
    if tab == nil then return end
    local cols = tab:get_size().cols
    local overrides = window:get_config_overrides() or {}
    local default_font_size = 14
    if cols >= 300 then overrides.font_size = 15 end

    if overrides.font_size ~= default_font_size then window:set_config_overrides({ font_size = default_font_size }) end
end)

-- tab bar
config.tab_max_width = 24
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = false
wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
    local cwd = tab.active_pane.current_working_dir
    local process_text = tab.active_pane.foreground_process_name
    local label = ""

    if process_text == nil then process_text = "" end

    if cwd == nil then cwd = "" end

    local dir_name = tostring(cwd):match("([^/]+)$")
    local process = tostring(process_text):match("([^/]+)$")

    if process == nil or process == "zsh" then
        label = dir_name ~= nil and dir_name or "-*-"
    else
        label = process .. " @ " .. dir_name
    end

    if #label > max_width - 2 then label = string.sub(label, 1, max_width - 3) .. "…" end

    return " " .. label .. " "
end)

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
        key = "l",
        mods = "CMD|SHIFT",
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
            pane:split({ direction = "Right", size = size })
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
    {
        key = "t",
        mods = "LEADER",
        action = wezterm.action_callback(function(window, cur_pane)
            local cur_tab = window:active_tab()
            local panes = cur_tab:panes_with_info()

            local get_newest_tab = function()
                local tabs = window:mux_window():tabs_with_info()
                local max_idx = 0
                local newest_tab = nil
                for _, tab in ipairs(tabs) do
                    if tab.index >= max_idx then
                        max_idx = tab.index
                        newest_tab = tab.tab
                    end
                end

                return newest_tab
            end

            local contains = function(tbl, val)
                for _, entry in ipairs(tbl) do
                    if entry == val then return true end
                end

                return false
            end

            window:perform_action(act.SpawnTab({ DomainName = "local" }), cur_pane)
            local new_tab = get_newest_tab()
            new_tab:activate()

            local working_new_pane = new_tab:active_pane()
            local seen_pane_ids = {}
            local last_left_col = 0
            local last_top_row = 0
            while #seen_pane_ids ~= #panes do
                for _, pane in ipairs(panes) do
                    if contains(seen_pane_ids, pane.pane:pane_id()) then goto continue end
                    local cwd = pane.pane:get_current_working_dir()

                    -- "main" pane already exists
                    if pane.left == 0 and pane.top == 0 then
                        table.insert(seen_pane_ids, pane.pane:pane_id())
                        goto continue
                    end

                    -- same starting col -> split into top/bottom
                    if pane.left == last_left_col then
                        working_new_pane = working_new_pane:split({ cwd = cwd.path, direction = "Bottom" })
                        last_top_row = pane.top

                    -- same starting row -> split into left/right
                    elseif pane.top == last_top_row then
                        working_new_pane = working_new_pane:split({ cwd = cwd.path, direction = "Right" })
                        last_left_col = pane.left
                    end

                    table.insert(seen_pane_ids, pane.pane:pane_id())
                    ::continue::
                end
            end
        end),
    },
    { key = "+", mods = "CMD", action = act.IncreaseFontSize },
    { key = "-", mods = "CMD", action = act.DecreaseFontSize },
    { key = ".", mods = "CMD", action = act.ResetFontSize },
    { key = "u", mods = "LEADER", action = act.QuickSelect },
    {
        key = ",",
        mods = "LEADER",
        action = act.PromptInputLine({
            description = "New tab name",
            action = wezterm.action_callback(function(window, pane, line)
                if line then window:active_tab():set_title(line) end
            end),
        }),
    },
    {
        key = "$",
        mods = "LEADER",
        action = act.PromptInputLine({
            description = "New session name",
            action = wezterm.action_callback(function(window, pane, line)
                if line then wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line) end
            end),
        }),
    },
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
table.insert(link_rules, {
    regex = [[\b([A-Z]{2,9}?-\d+?)\b]],
    format = "https://jira.kdc.capitalone.com/browse/$1",
})
config.hyperlink_rules = link_rules

return config
