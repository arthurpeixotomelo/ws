local wezterm = require 'wezterm'
local act = wezterm.action
local last_sample_time = 0
local cached_metrics = "..."
local config = wezterm.config_builder()

config.status_update_interval = 50
config.default_prog = { '/usr/bin/nu' }
config.warn_about_missing_glyphs = false
config.font = wezterm.font('CodeNewRoman Nerd Font')
config.quick_select_patterns = {
    '[0-9a-f]{7,40}',               -- Git commit hashes
    '[0-9a-fA-F-]{36}',             -- UUIDs
    '\\b[0-9]{1,3}(\\.[0-9]{1,3}){3}\\b', -- IPv4 addresses
}
config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
    { key = '|', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '-', mods = 'LEADER',       action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'z', mods = 'LEADER',       action = act.TogglePaneZoomState },
    { key = 'Space', mods = 'LEADER',   action = act.QuickSelect },
    { key = 'w', mods = 'LEADER',       action = act.ShowLauncherArgs { flags = 'WORKSPACES' } },
    { key = '1', mods = 'LEADER',       action = act.SwitchToWorkspace { name = 'sys' } },
    { key = '2', mods = 'LEADER',       action = act.SwitchToWorkspace { name = 'code' } },
}

wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
    return string.format('[%s] %s', wezterm.mux.get_active_workspace(), pane.title)
end)

wezterm.on("update-status", function(window, pane)
    local now = tonumber(wezterm.time.now():format("%s%.3f"))

    if now - last_sample_time >= 0.5 then
        local success, stdout, _ = wezterm.run_child_process({ "nu", wezterm.home_dir .. "/ws/config/wezterm/status.nu" })
        if success and stdout then
            cached_metrics = stdout:gsub("\n$", "")
        end
        last_sample_time = now
    end

    local elements = {}

    if window:leader_is_active() then
        table.insert(elements, { Foreground = { Color = '#fab387' } })
        table.insert(elements, { Attribute = { Intensity = 'Bold' } })
        table.insert(elements, { Text = '\u{f030c}  ' })
    end

    table.insert(elements, { Foreground = { Color = '#cdd6f4' } })
    table.insert(elements, { Text = ' ' .. cached_metrics .. ' ' })

    window:set_right_status(wezterm.format(elements))
end)

wezterm.on("gui-startup", function(cmd)
    local tab1, pane1, window = wezterm.mux.spawn_window({
        workspace = "sys",
        cwd = wezterm.home_dir,
    })
    local tab2, pane2 = window:spawn_tab({})
    window:gui_window():maximize()
    pane1:send_text("btop\n")
    pane2:send_text("spf\n")
    window:spawn_tab({})
end)

return config