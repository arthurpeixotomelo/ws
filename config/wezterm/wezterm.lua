local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local mux = wezterm.mux
local gui = wezterm.gui

wezterm.on("gui-startup", function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

wezterm.on("update-status", function(window, pane)
    local success, stdout, stderr = wezterm.run_child_process({
        "nu", "~/ws/config/wezterm/status.nu"
    })

    if success then
        window:set_right_status(stdout)
    end
end)

config.front_end = "WebGpu"
config.window_decorations = "INTEGRATED_BUTTONS"
config.default_prog = { 'C:/Program Files/nu/bin/nu.exe' }
config.scroll_to_bottom_on_input = false

return config